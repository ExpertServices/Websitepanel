// Copyright (c) 2012, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using Microsoft.Web.Deployment;
using Microsoft.Web.PlatformInstaller;
using Installer = Microsoft.Web.PlatformInstaller.Installer;

namespace WebsitePanel.Server.Code
{
    public class WpiUpdatedDeploymentParameter
    {
        public string Name;
        public string Value;
        public DeploymentWellKnownTag WellKnownTags;
    }

    public class WpiHelper
    {
        #region public consts

        public const string DeafultLanguage = "en";

        #endregion

        #region private fields

        private readonly List<string> _feeds;
        private string _webPIinstallersFolder;
        //private const string MainWpiFeed = "https://www.microsoft.com/web/webpi/3.0/webproductlist.xml";
        private const string MainWpiFeed = "https://www.microsoft.com/web/webpi/4.0/WebProductList.xml";
        private const string IisChoiceProduct = "StaticContent";
        private const string WebMatrixChoiceProduct = "WebMatrix";
        private ProductManager _productManager;
        private bool _installCompleted;
        private InstallManager _installManager;
        private string _LogFileDirectory = string.Empty;
        string _resourceLanguage = DeafultLanguage;
        private const DeploymentWellKnownTag databaseEngineTags =
                    DeploymentWellKnownTag.Sql |
                    DeploymentWellKnownTag.MySql |
                    DeploymentWellKnownTag.SqLite |
                    DeploymentWellKnownTag.VistaDB |
                    DeploymentWellKnownTag.FlatFile;

        #endregion private fields

        public WpiHelper(IEnumerable<string> feeds)
        {
            _feeds = new List<string>();
            _feeds.AddRange(feeds);

            Initialize();
        }

        private void Initialize()
        {
            // insert Main WebPI xml file
            if (!_feeds.Contains(MainWpiFeed, StringComparer.OrdinalIgnoreCase))
            {
                _feeds.Insert(0, MainWpiFeed);
            }

            // create cache folder if not exists
            //_webPIinstallersFolder = Environment.ExpandEnvironmentVariables(@"%LocalAppData%\Microsoft\Web Platform Installer\installers");
            _webPIinstallersFolder = Path.Combine(
                Environment.ExpandEnvironmentVariables("%SystemRoot%"), 
                "Temp\\zoo.wpi\\AppData\\Local\\Microsoft\\Web Platform Installer\\installers" );

            if (!Directory.Exists(_webPIinstallersFolder))
            {
                Directory.CreateDirectory(_webPIinstallersFolder);
            }

            // load feeds
            _productManager = new ProductManager();
            

            foreach (string feed in _feeds)
            {
                Log(string.Format("Loading {0}", feed));
                if (feed.StartsWith("https://www.microsoft.com", StringComparison.OrdinalIgnoreCase))
                {
                    _productManager.Load(new Uri(feed), true, true, true, _webPIinstallersFolder);
                }
                else
                {
                    _productManager.LoadExternalFile(new Uri(feed));
                }
            }

            Log(string.Format("{0} products loaded", _productManager.Products.Count));

            LogDebugInfo();
        }

        public void SetResourceLanguage(string resourceLanguage)
        {
            _resourceLanguage = resourceLanguage;
            _productManager.SetResourceLanguage(resourceLanguage);
        }

        #region Public interface

        public List<Product> GetProducts()
        {
            return GetProducts(null,null);
        }

        public List<Language> GetLanguages()
        {
            List<Language> languages = new List<Language>();

            foreach (Product product in GetProducts())
            {
                if (null!=product.Installers)
                {
                    foreach (Installer installer in product.Installers)
                    {
                        Language lang = installer.Language;
                        if (null!=lang && !languages.Contains(lang))
                        {
                            languages.Add(lang);
                        }
                    }
                }
            }

            return languages;
        }

        public void CancelInstallProducts()
        {
            if (_installManager!= null)
            {
                _installManager.Cancel();
            }
        }

        private List<Installer> GetInstallers(List<Product> productsToInstall, Language lang)
        {
            List<Installer> installersToUse = new List<Installer>();
            foreach (Product product in productsToInstall)
            {
                Installer installer = product.GetInstaller(lang);
                if (null != installer)
                {
                    installersToUse.Add(installer);
                }
            }

            return installersToUse;
        }


        public List<Product> GetProductsWithDependencies(IEnumerable<string> productIdsToInstall )
        {
            List<string> updatedProductIdsToInstall = new List<string>();
            // add iis chioce product to force iis (not-iisexpress/webmatrix) branch
            updatedProductIdsToInstall.Add(IisChoiceProduct);
            updatedProductIdsToInstall.AddRange(productIdsToInstall);

            List<Product> productsToInstall = new List<Product>();

            foreach (string productId in updatedProductIdsToInstall)
            {
                Log(string.Format("Product {0} to be installed", productId));

                Product product = _productManager.GetProduct(productId);
                if (null == product)
                {
                    Log(string.Format("Product {0} not found", productId));
                    continue;
                }
                if (product.IsInstalled(true))
                {
                    Log(string.Format("Product {0} is installed", product.Title));
                }
                else
                {
                    Log(string.Format("Adding product {0} with dependencies", product.Title));
                    // search and add dependencies but skip webmatrix/iisexpress branches
                    AddProductWithDependencies(product, productsToInstall, WebMatrixChoiceProduct);
                }
            }

            return productsToInstall;
        }

        public string GetLogFileDirectory()
        {
            return _LogFileDirectory;
        }


        private Language GetLanguage(string languageId)
        {
            if (!string.IsNullOrEmpty(languageId))
            {
                return _productManager.GetLanguage(languageId);    
            }

            return _productManager.GetLanguage(DeafultLanguage);
        }


        // GetTabs
        public ReadOnlyCollection<Tab> GetTabs()
        {
            return _productManager.Tabs;
        }

        public Tab GetTab(string tabId)
        {
            return _productManager.GetTab(tabId);
        }

        // GetKeywords
        public ReadOnlyCollection<Keyword> GetKeywords()
        {
            return _productManager.Keywords;
        }

        public List<Product> GetApplications(string keywordId)
        {

            Keyword keyword = null;
            if (!string.IsNullOrEmpty(keywordId))
            {
                keyword = _productManager.GetKeyword(keywordId);
            }



            List<Product> products = new List<Product>();

            Language lang = GetLanguage(_resourceLanguage);
            Language langDefault = GetLanguage(DeafultLanguage);

            foreach (Product product in _productManager.Products)
            {
                if (!product.IsApplication)
                {
                    // skip
                    continue;
                }

                //Check language
                if (
                    lang.AvailableProducts.Contains(product) ||
                    langDefault.AvailableProducts.Contains(product)
                    )
                {
                    if (null == keyword)
                    {
                        products.Add(product);
                    }
                    else if (product.Keywords.Contains(keyword))
                    {
                        products.Add(product);
                    }

                }

            }

            //Sort by Title
            products.Sort(delegate(Product a, Product b)
            {
                return a.Title.CompareTo(b.Title);
            });


            return products;
        }

        public Product GetProduct(string productId)
        {
            return _productManager.GetProduct(productId);
        }

        public IList<DeclaredParameter> GetAppDecalredParameters(string productId)
        {
            Product app = _productManager.GetProduct(productId);
            Installer appInstaller = app.GetInstaller(GetLanguage(null));
            return appInstaller.MSDeployPackage.DeclaredParameters;
        }

        public void InstallProducts(
            IEnumerable<string> productIdsToInstall,
            string languageId,
            EventHandler<InstallStatusEventArgs> installStatusUpdatedHandler,
            EventHandler<EventArgs> installCompleteHandler)
        {
    
            // Get products & dependencies list to install
            List<Product> productsToInstall = GetProductsWithDependencies(productIdsToInstall);

            // Get installers
            Language lang = GetLanguage(languageId);
            List<Installer> installersToUse =  GetInstallers(productsToInstall, lang );

        
            // Prepare install manager & set event handlers
            _installManager = new InstallManager();
            _installManager.Load(installersToUse);


            if (null != installStatusUpdatedHandler)
            {
                _installManager.InstallerStatusUpdated += installStatusUpdatedHandler;
            }
            _installManager.InstallerStatusUpdated += InstallManager_InstallerStatusUpdated;

            if (null != installCompleteHandler)
            {
                _installManager.InstallCompleted += installCompleteHandler;
            }
            _installManager.InstallCompleted += InstallManager_InstallCompleted;

            // Download installer files
            foreach (InstallerContext installerContext in _installManager.InstallerContexts)
            {
                if (null != installerContext.Installer.InstallerFile)
                {
                    string failureReason;
                    if (!_installManager.DownloadInstallerFile(installerContext, out failureReason))
                    {
                        Log(string.Format("DownloadInstallerFile '{0}' failed: {1}",
                                          installerContext.Installer.InstallerFile.InstallerUrl, failureReason));
                    }
                }
            }

            if (installersToUse.Count > 0)
            {
                // Start installation
                _installCompleted = false;
                Log("_installManager.StartInstallation()");
                _installManager.StartInstallation();
                
                Log("_installManager.StartInstallation() done");
                while (!_installCompleted)
                {
                    Thread.Sleep(100);
                }

                //save logs
                SaveLogDirectory();

              
                _installCompleted = false;
            }
            else
            {
                Log("Nothing to install");
            }

        }

        public bool InstallApplication(
            string appId,
            List<WpiUpdatedDeploymentParameter> updatedValues, 
            string languageId,
            EventHandler<InstallStatusEventArgs> installStatusUpdatedHandler,
            EventHandler<EventArgs> installCompleteHandler,
            out string log,
            out string failedMessage
            )
        {

            Product app = GetProduct(appId);
            Installer appInstaller = app.GetInstaller(GetLanguage(languageId));
            WpiAppInstallLogger logger = new WpiAppInstallLogger();

            if (null != installStatusUpdatedHandler)
            {
                _installManager.InstallerStatusUpdated += installStatusUpdatedHandler;
            }
            _installManager.InstallerStatusUpdated += logger.HanlderInstallerStatusUpdated;

            if (null != installCompleteHandler)
            {
                _installManager.InstallCompleted += installCompleteHandler;
            }
            _installManager.InstallCompleted += logger.HandlerInstallCompleted;

            // set updated parameters
            foreach (WpiUpdatedDeploymentParameter parameter in updatedValues)
            {
                if (!string.IsNullOrEmpty(parameter.Value))
                {
                    appInstaller.MSDeployPackage.SetParameters[parameter.Name] = parameter.Value;
                }
            }

            DeploymentWellKnownTag dbTag = (DeploymentWellKnownTag)GetDbTag(updatedValues);

            // remove parameters with alien db tags
            foreach (DeclaredParameter parameter in appInstaller.MSDeployPackage.DeclaredParameters)
            {
                if (IsAlienDbTaggedParameter(dbTag, parameter))
                {
                    appInstaller.MSDeployPackage.RemoveParameters.Add(parameter.Name);
                }
            }

            // skip alien directives
            RemoveUnusedProviders(appInstaller.MSDeployPackage, dbTag);

            _installCompleted = false;
            Log("_installManager.StartApplicationInstallation()");
            _installManager.StartApplicationInstallation();
            while (!_installCompleted)
            {
                Thread.Sleep(1000);
            }
            Log("_installManager.StartApplicationInstallation() _installCompleted");

            //save logs
            SaveLogDirectory();

            _installCompleted = false;

            log = logger.GetLog();
            failedMessage = logger.FailedMessage;
            
            return !logger.IsFailed;
        }

        public bool IsKeywordApplication(Keyword keyword)
        {
            //if all products are Application
            foreach (Product product in keyword.Products)
            {
                if (!product.IsApplication)
                {
                    return false;
                }
            }

            return true;

        }

        #endregion Public interface


        #region private members

        private void LogDebugInfo()
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("Products: ");

            sb.Append("Tabs: ").AppendLine();
            foreach (Tab tab in _productManager.Tabs)
            {
                sb.AppendFormat("\t{0}, FromCustomFeed = {1}", tab.Name, tab.FromCustomFeed).AppendLine();
                foreach (string f in tab.FeedList)
                {
                    sb.AppendFormat("\t\t{0}", f).AppendLine();
                }
                sb.AppendLine();
            }
            sb.AppendLine();

            sb.Append("Keywords: ").AppendLine().Append("\t");
            foreach (Keyword keyword in _productManager.Keywords)
            {
                sb.Append(keyword.Id).Append(",");
            }
            sb.AppendLine();

            sb.Append("Languages: ").AppendLine().Append("\t");
            foreach (Language language in _productManager.Languages)
            {
                sb.Append(language.Name).Append(",");
            }
            sb.AppendLine();

            Log(sb.ToString());
        }

        private static void Log(string message)
        {
//#if DEBUG
            Debug.WriteLine(string.Format("[{0}] WpiHelper: {1}", Process.GetCurrentProcess().Id, message));
            Console.WriteLine(message);
//#endif
        }

        public List<Product> GetProducts(string FeedLocation, string keywordId)
        {
            Keyword keyword = null;
            if (!string.IsNullOrEmpty(keywordId))
            {
                keyword = _productManager.GetKeyword(keywordId);
            }

            List<Product> products = new List<Product>();

            foreach (Product product in _productManager.Products)
            {
                if (!string.IsNullOrEmpty(FeedLocation) && string.Compare(product.FeedLocation, FeedLocation, StringComparison.OrdinalIgnoreCase) != 0)
                {
                    // if FeedLocation defined, then select products only from this feed location
                    continue;
                }

                if (null == product.Installers || product.Installers.Count == 0)
                {
                    // skip this product
                    // usually product without intsallers user as product detection
                    continue;
                }

                if (null == keyword)
                {
                    products.Add(product);
                }
                else if (product.Keywords.Contains(keyword))
                {
                    products.Add(product);
                }
            }

            //Sort by Title
            products.Sort(delegate(Product a, Product b)
            {
                return a.Title.CompareTo(b.Title);
            });

            return products;
        }

        public List<Product> GetProductsFiltered(string filter)
        {
           
            List<Product> products = new List<Product>();

            foreach (Product product in _productManager.Products)
            {
                if (null == product.Installers || product.Installers.Count == 0)
                {
                    // skip this product
                    // usually product without intsallers user as product detection
                    continue;
                }

                if (string.IsNullOrEmpty(filter))
                {
                    products.Add(product);
                }
                else if (product.Title.ToLower().Contains(filter.ToLower()))
                {
                    products.Add(product);
                }
            }

            //Sort by Title
            products.Sort(delegate(Product a, Product b)
            {
                return a.Title.CompareTo(b.Title);
            });


            return products;
        }


        private void InstallManager_InstallCompleted(object sender, EventArgs e)
        {
            Log("Installation completed");
            if (null != _installManager)
            {
                /*
                try
                {
                    _installManager.Dispose();
                } catch(Exception ex)
                {
                    Log("InstallManager_InstallCompleted Exception: "+ex.ToString());
                }
                _installManager = null;
                */
            }
            _installCompleted = true;
        }

        private void InstallManager_InstallerStatusUpdated(object sender, InstallStatusEventArgs e)
        {
            Log(string.Format("{0}: {1}. {2} Progress: {3}",
                e.InstallerContext.ProductName,
                e.InstallerContext.InstallationState,
                e.InstallerContext.ReturnCode.DetailedInformation,
                e.ProgressValue));
        }

        private static void AddProductWithDependencies(Product product, List<Product> productsToInstall, string skipProduct)
        {
            if (!productsToInstall.Contains(product))
            {
                productsToInstall.Add(product);
            }

            ICollection<Product> missingDependencies = product.GetMissingDependencies(productsToInstall);
            if (missingDependencies != null)
            {
                foreach (Product dependency in missingDependencies)
                {
                    if (string.Equals(dependency.ProductId, skipProduct, StringComparison.OrdinalIgnoreCase))
                    {
                        Log(string.Format("Product {0} is iis express dependency, skip it", dependency.Title));
                        continue;
                    }

                    AddProductWithDependencies(dependency, productsToInstall, skipProduct);
                }
            }
        }

        private void SaveLogDirectory()
        {
            Log("SaveLogDirectory");
            foreach (InstallerContext ctx in _installManager.InstallerContexts)
            {
                Log(ctx.LogFileDirectory);
                _LogFileDirectory = ctx.LogFileDirectory;
                break;

            }
        }

        private DeploymentWellKnownTag GetDbTag(List<WpiUpdatedDeploymentParameter> parameters)
        {
            foreach (WpiUpdatedDeploymentParameter parameter in parameters)
            {
                if ((parameter.WellKnownTags & databaseEngineTags) != 0)
                {
                    return (DeploymentWellKnownTag)Enum.Parse(
                        typeof(DeploymentWellKnownTag),
                        (parameter.WellKnownTags & databaseEngineTags).ToString().Split(',')[0]);
                }
            }

            return DeploymentWellKnownTag.None;
        }

        private static bool IsAlienDbTaggedParameter(DeploymentWellKnownTag dbTag, DeclaredParameter parameter)
        {
#pragma warning disable 612,618
            return (parameter.Tags & databaseEngineTags) != DeploymentWellKnownTag.None 
                   && 
                   (parameter.Tags & dbTag) == DeploymentWellKnownTag.None;
#pragma warning restore 612,618
        }

        private static void RemoveUnusedProviders(MSDeployPackage msDeployPackage, DeploymentWellKnownTag dbTag)
        {
            List<string> providersToRemove = new List<string>();

            switch (dbTag)
            {
                case DeploymentWellKnownTag.MySql:
                    providersToRemove.Add("dbFullSql");
                    providersToRemove.Add("DBSqlite");
                    break;
                case DeploymentWellKnownTag.Sql:
                    providersToRemove.Add("dbMySql");
                    providersToRemove.Add("DBSqlite");
                    break;
                case DeploymentWellKnownTag.FlatFile:
                    providersToRemove.Add("dbFullSql");
                    providersToRemove.Add("DBSqlite");
                    providersToRemove.Add("dbMySql");
                    break;
                case DeploymentWellKnownTag.SqLite:
                    providersToRemove.Add("dbFullSql");
                    providersToRemove.Add("dbMySql");
                    break;
                case DeploymentWellKnownTag.VistaDB:
                    providersToRemove.Add("dbFullSql");
                    providersToRemove.Add("DBSqlite");
                    providersToRemove.Add("dbMySql");
                    break;
                case DeploymentWellKnownTag.SqlCE:
                    providersToRemove.Add("dbFullSql");
                    providersToRemove.Add("DBSqlite");
                    providersToRemove.Add("dbMySql");
                    break;
                default:
                    break;
            }

            foreach (string provider in providersToRemove)
            {
                msDeployPackage.SkipDirectives.Add(string.Format("objectName={0}", provider));
            }
        }

        #endregion private members
    }

    class WpiAppInstallLogger
    {
        private StringBuilder sb;
        private InstallReturnCode _installReturnCode;
        private string _failedMessage = string.Empty;

        public WpiAppInstallLogger()
        {
            sb = new StringBuilder();
        }

        public InstallReturnCode ReturnCode
        {
            get { return _installReturnCode; }
        }

        public string FailedMessage
        {
            get { return _failedMessage; }
        }

        public bool IsFailed
        {
            get
            {
                if (null != _installReturnCode)
                {
                    return _installReturnCode.Status == InstallReturnCodeStatus.Failure ||
                           _installReturnCode.Status == InstallReturnCodeStatus.FailureRebootRequired;
                }
                return false;
            }
        }

        public void HanlderInstallerStatusUpdated(object sender, InstallStatusEventArgs e)
        {
            sb.AppendFormat("{0}: {1}. {2} Progress: {3}",
                            e.InstallerContext.ProductName,
                            e.InstallerContext.InstallationState,
                            e.InstallerContext.ReturnCode.DetailedInformation,
                            e.ProgressValue).AppendLine();
        }

        public void HandlerInstallCompleted(object sender, EventArgs e)
        {
            InstallManager installManager = sender as InstallManager;
            if (null != installManager)
            {
                InstallerContext installerContext;
                if (null != installManager.InstallerContexts && installManager.InstallerContexts.Count>0)
                {
                    installerContext = installManager.InstallerContexts[0];
                    _installReturnCode = installerContext.ReturnCode;
                }
            }

            if (null != _installReturnCode)
            {
                _failedMessage = string.Format("{0}: {1}",
                                               _installReturnCode.Status,
                                               _installReturnCode.DetailedInformation);
                sb.AppendFormat("Return Code: {0}", _failedMessage).AppendLine();
            }
            sb.AppendLine("Installation completed");
        }

        public string GetLog()
        {
            return sb.ToString();
        }
    }
}
