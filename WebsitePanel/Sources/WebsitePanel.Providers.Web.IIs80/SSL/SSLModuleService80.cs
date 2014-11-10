using System;
using System.Globalization;
using System.IO;
using CertEnrollInterop;
using WebsitePanel.Providers.Common;
using WebsitePanel.Server.Utils;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Web.Administration;

namespace WebsitePanel.Providers.Web.Iis
{
    public class SSLModuleService80 : SSLModuleService
    {
	    private const string CertificateStoreName = "WebHosting";

        public bool UseSNI { get; private set; }
        public bool UseCCS { get; private set; }
        public string CCSUncPath { get; private set; }
        public string CCSCommonPassword { get; private set; }
        
        public SSLModuleService80(SslFlags sslFlags, string ccsUncPath, string ccsCommonPassword)
        {
            UseSNI = sslFlags.HasFlag(SslFlags.Sni);
            UseCCS = sslFlags.HasFlag(SslFlags.CentralCertStore);
            CCSUncPath = ccsUncPath;
            CCSCommonPassword = ccsCommonPassword;
        }

        public new SSLCertificate InstallCertificate(SSLCertificate cert, WebSite website)
        {
            try
            {
                var response = Activator.CreateInstance(Type.GetTypeFromProgID("X509Enrollment.CX509Enrollment", true)) as CX509Enrollment;
                if (response == null)
                {
                    throw new Exception("Cannot create instance of X509Enrollment.CX509Enrollment");
                }

                response.Initialize(X509CertificateEnrollmentContext.ContextMachine);
                response.InstallResponse(
                    InstallResponseRestrictionFlags.AllowUntrustedRoot,
                    cert.Certificate, EncodingType.XCN_CRYPT_STRING_BASE64HEADER,
                    null
                );

                // At this point, certificate has been installed into "Personal" store
                // We need to move it into "WebHosting" store
                // Get certificate
                var servercert = GetServerCertificates(StoreName.My.ToString()).Single(c => c.FriendlyName == cert.FriendlyName);
                if (UseCCS)
                {
                    // Delete existing certificate, if any. This is needed to install a new binding
                    if (CheckCertificate(website))
                    {
                        DeleteCertificate(GetCurrentSiteCertificate(website), website);
                    }
                }
                
                // Get certificate data - the one we just added to "Personal" store
                var storeMy = new X509Store(StoreName.My, StoreLocation.LocalMachine);
                storeMy.Open(OpenFlags.MaxAllowed);
                X509CertificateCollection existCerts2 = storeMy.Certificates.Find(X509FindType.FindBySerialNumber, servercert.SerialNumber, false);
                var certData = existCerts2[0].Export(X509ContentType.Pfx);
                storeMy.Close();

                if (UseCCS)
                {
                    // Revert to InstallPfx to install new certificate - this also adds binding
                    InstallPfx(certData, string.Empty, website);
                }
                else
                {
                    // Add new certificate to "WebHosting" store
                    var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);
                    var x509Cert = new X509Certificate2(certData);
                    store.Open(OpenFlags.ReadWrite);
                    store.Add(x509Cert);
                    store.Close();
                }

                // Remove certificate from "Personal" store
                storeMy.Open(OpenFlags.MaxAllowed);
                X509CertificateCollection existCerts = storeMy.Certificates.Find(X509FindType.FindBySerialNumber, servercert.SerialNumber, false);
                storeMy.Remove((X509Certificate2)existCerts[0]);
                storeMy.Close();
                // Fill object with certificate data
                cert.SerialNumber = servercert.SerialNumber;
                cert.ValidFrom = servercert.ValidFrom;
                cert.ExpiryDate = servercert.ExpiryDate;
                cert.Hash = servercert.Hash;
                cert.DistinguishedName = servercert.DistinguishedName;

                if (!UseCCS)
                {
                    if (CheckCertificate(website))
                    {
                        DeleteCertificate(GetCurrentSiteCertificate(website), website);
                    }

                    AddBinding(cert, website);
                }
            }
            catch (Exception ex)
            {
                Log.WriteError("Error adding SSL certificate", ex);
                cert.Success = false;
            }

            return cert;
        }

        public new List<SSLCertificate> GetServerCertificates()
		{
            // Use Web Hosting store - new for IIS 8.0
            return GetServerCertificates(CertificateStoreName);
		}
        
        public new SSLCertificate ImportCertificate(WebSite website)
		{
			SSLCertificate certificate;

			try
			{
			    certificate = GetCurrentSiteCertificate(website);
			}
			catch (Exception ex)
			{
                certificate = new SSLCertificate
                {
                    Success = false, 
                    Certificate = ex.ToString()
                };
			}

			return certificate;
		}
        
        public new SSLCertificate InstallPfx(byte[] certificate, string password, WebSite website)
		{
            SSLCertificate newcert, oldcert = null;

            // Ensure we perform operations safely and preserve the original state during all manipulations, save the oldcert if one is used
		    if (CheckCertificate(website))
		    {
		        oldcert = GetCurrentSiteCertificate(website);
		    }

		    X509Certificate2 x509Cert;
            var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);

		    if (UseCCS)
		    {
		        // We need to use this constructor or we won't be able to export this certificate
		        x509Cert = new X509Certificate2(certificate, password, X509KeyStorageFlags.Exportable);

		        var certData = x509Cert.Export(X509ContentType.Pfx);
		        var convertedCert = new X509Certificate2(certData, string.Empty, X509KeyStorageFlags.Exportable);

		        // Attempts to move certificate to CCS UNC path
		        try
		        {
		            // Create a stream out of that new certificate
		            certData = convertedCert.Export(X509ContentType.Pfx, CCSCommonPassword);
		            
                    // Open UNC path and set path to certificate subject
		            var filename = (CCSUncPath.EndsWith("/") ? CCSUncPath: CCSUncPath + "/") + x509Cert.GetNameInfo(X509NameType.SimpleName, false) + ".pfx";
		            var writer = new BinaryWriter(File.Open(filename, FileMode.Create));
		            writer.Write(certData);
		            writer.Flush();
		            writer.Close();
		            // Certificated saved
		        }
		        catch (Exception ex)
		        {
		            // Log error
		            Log.WriteError("SSLModuleService could not save certificate to Centralized Certificate Store", ex);
		            // Re-throw
		            throw;
		        }
		    }
		    else
		    {
		        x509Cert = new X509Certificate2(certificate, password);

		        // Step 1: Register X.509 certificate in the store
		        // Trying to keep X.509 store open as less as possible
		        try
		        {
		            store.Open(OpenFlags.ReadWrite);

                    store.Add(x509Cert);
		        }
		        catch (Exception ex)
		        {
		            Log.WriteError(String.Format("SSLModuleService could not import PFX into X509Store('{0}', '{1}')", store.Name, store.Location), ex);
		            // Re-throw error
		            throw;
		        }
		        finally
		        {
		            store.Close();
		        }
		    }

		    // Step 2: Instantiate a copy of new X.509 certificate
			try
			{
				store.Open(OpenFlags.ReadWrite);
			    newcert = GetSSLCertificateFromX509Certificate2(x509Cert);
			}
			catch (Exception ex)
			{
			    if (!UseCCS)
			    {
			        // Rollback X.509 store changes
			        store.Remove(x509Cert);
			    }
			    // Log error
				Log.WriteError("SSLModuleService could not instantiate a copy of new X.509 certificate. All previous changes have been rolled back.", ex);
				// Re-throw
				throw;
			}
			finally
			{
				store.Close();
			}

		    if (!UseCCS)
		    {
		        // Step 3: Remove old certificate from the web site if any
		        try
		        {
		            store.Open(OpenFlags.ReadWrite);
		            // Check if certificate already exists, remove it.
		            if (oldcert != null)
		                DeleteCertificate(oldcert, website);
		        }
		        catch (Exception ex)
		        {
		            // Rollback X.509 store changes
		            store.Remove(x509Cert);
		            // Log the error
		            Log.WriteError(
		                String.Format("SSLModuleService could not remove existing certificate from '{0}' web site. All changes have been rolled back.", website.Name), ex);
		            // Re-throw
		            throw;
		        }
		        finally
		        {
		            store.Close();
		        }
		    }

		    // Step 4: Register new certificate with HTTPS binding on the web site
			try
			{
                //if (!UseCCS)
                //{
                //    store.Open(OpenFlags.ReadWrite);
                //}

                AddBinding(newcert, website);
			}
			catch (Exception ex)
			{
			    if (!UseCCS)
			    {
			        // Install old certificate back if any
                    store.Open(OpenFlags.ReadWrite);
			        if (oldcert != null)
			            InstallCertificate(oldcert, website);
			        // Rollback X.509 store changes
			        store.Remove(x509Cert);
    				store.Close();
			    }
			    // Log the error
				Log.WriteError(
					String.Format("SSLModuleService could not add new X.509 certificate to '{0}' web site. All changes have been rolled back.", website.Name), ex);
				// Re-throw
				throw;
			}
			
			return newcert;
		}

        public new byte[] ExportPfx(string serialNumber, string password)
        {
            if (UseCCS)
            {
                // This is not a good way to do it
                // Find cert by somehow perhaps first looking in the database? There vi kan lookup the serialnumber and find the hostname needed to create the path to the cert in CCS and then we can load the certdata into a cert and do a export with new password.
                // Another solution would be to look through all SSL-bindings on all sites until we found the site with the binding that has this serialNumber. But serialNumber is not good enough, we need hash that is unique and present in bindingInfo
                // A third solution is to iterate over all files in CCS, load them into memory and find the one with the correct serialNumber, but that cannot be good if there are thousands of files...
                foreach (var file in Directory.GetFiles(CCSUncPath))
                {
		            var fileStream = File.OpenRead(file);

		            // Read certificate data from file
		            var certData = new byte[fileStream.Length];
		            fileStream.Read(certData, 0, (int) fileStream.Length);
		            var convertedCert = new X509Certificate2(certData, CCSCommonPassword, X509KeyStorageFlags.Exportable);

                    fileStream.Close();

                    if (convertedCert.SerialNumber == serialNumber)
                    {
                        return convertedCert.Export(X509ContentType.Pfx, password);
                    }
                }
            }

            var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);
            store.Open(OpenFlags.ReadOnly);
            var cert = store.Certificates.Find(X509FindType.FindBySerialNumber, serialNumber, false)[0];
            var exported = cert.Export(X509ContentType.Pfx, password);
            return exported;
        }


        public new void AddBinding(SSLCertificate certificate, WebSite website)
        {
            using (var srvman = GetServerManager())
            {
                var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly);
                
                // Look for dedicated ip
                var dedicatedIp = SiteHasBindingWithDedicatedIp(srvman, website);

                var bindingInformation = string.Format("{0}:443:{1}", website.SiteIPAddress, dedicatedIp ? "" : certificate.Hostname);

                Binding siteBinding = UseCCS ? 
                    srvman.Sites[website.SiteId].Bindings.Add(bindingInformation, "https") : 
                    srvman.Sites[website.SiteId].Bindings.Add(bindingInformation, certificate.Hash, store.Name);
                
                if (UseSNI)
                {
                    siteBinding.SslFlags |= SslFlags.Sni;
                }
                if (UseCCS)
                {
                    siteBinding.SslFlags |= SslFlags.CentralCertStore;
                }

                store.Close();

                srvman.CommitChanges();
            }
        }

		public new ResultObject DeleteCertificate(SSLCertificate certificate, WebSite website)
		{
			var result = new ResultObject() { IsSuccess = true };

		    if (certificate == null)
		    {
		        return result;
		    }

			try
			{
                // Regardless of the CCS setting on the server, we try to find and remove the certificate from both CCS and WebHosting Store. 
                // This is because we don't know how this was set when the certificate was added

			    if (!string.IsNullOrWhiteSpace(CCSUncPath) && Directory.Exists(CCSUncPath))
			    {
                    // This is where it will be if CCS is used
			        var path = GetCCSPath(certificate.Hostname);
			        if (File.Exists(path))
			        {
			            File.Delete(path);
			        }
			    }

                // Now delete all certs with the same serialnumber in WebHosting Store
                var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);
			    store.Open(OpenFlags.MaxAllowed);

			    var certs = store.Certificates.Find(X509FindType.FindBySerialNumber, certificate.SerialNumber, false);
			    foreach (var cert in certs)
			    {
			        store.Remove(cert);    
			    }

			    store.Close();

                // Remove binding from site
			    if (CheckCertificate(website))
			    {
			        RemoveBinding(certificate, website);
			    }
			}
			catch (Exception ex)
			{
                Log.WriteError(String.Format("Unable to delete certificate for website {0}", website.Name), ex);
				result.IsSuccess = false;
				result.AddError("", ex);
			}

			return result;
		}

		public new SSLCertificate GetCurrentSiteCertificate(WebSite website)
		{
		    using (var srvman = GetServerManager())
		    {
		        var site = srvman.Sites[website.SiteId];
		        var sslBinding = site.Bindings.First(b => b.Protocol == "https");

		        X509Certificate2 cert = null;

                // If the certificate is in the central store
		        if (((SslFlags)Enum.Parse(typeof(SslFlags), sslBinding["sslFlags"].ToString())).HasFlag(SslFlags.CentralCertStore))
		        {
		            // Let's try to match binding host and certificate filename
		            var path = GetCCSPath(sslBinding.Host);
		            if (File.Exists(path))
		            {
		                var fileStream = File.OpenRead(path);

		                // Read certificate data from file
		                var certData = new byte[fileStream.Length];
		                fileStream.Read(certData, 0, (int) fileStream.Length);
		                cert = new X509Certificate2(certData, CCSCommonPassword);
		                fileStream.Close();
		            }
		        }
		        else
		        {
		            var currentHash = sslBinding.CertificateHash;
		            var store = new X509Store(CertificateStoreName, StoreLocation.LocalMachine);
		            store.Open(OpenFlags.ReadOnly);

		            cert = store.Certificates.Cast<X509Certificate2>().Single(c => Convert.ToBase64String(c.GetCertHash()) == Convert.ToBase64String(currentHash));

		            store.Close();
		        }

		        return GetSSLCertificateFromX509Certificate2(cert);
		    }
		}

        private static List<SSLCertificate> GetServerCertificates(string certificateStoreName)
		{
            var store = new X509Store(certificateStoreName, StoreLocation.LocalMachine);

            List<SSLCertificate> certificates;
			
			try
			{
				store.Open(OpenFlags.ReadOnly);
			    certificates = store.Certificates.Cast<X509Certificate2>().Select(GetSSLCertificateFromX509Certificate2).ToList();
			}
			catch (Exception ex)
			{
				Log.WriteError(
					String.Format("SSLModuleService is unable to get certificates from X509Store('{0}', '{1}') and complete GetServerCertificates call", store.Name, store.Location), ex);
				// Re-throw exception
				throw;
			}
			finally
			{
				store.Close();
			}

			return certificates;
		}

        private string GetCCSPath(string bindingName)
        {
            return (CCSUncPath.EndsWith("/") ? CCSUncPath : CCSUncPath + "/") + bindingName + ".pfx";
        }

        private static SSLCertificate GetSSLCertificateFromX509Certificate2(X509Certificate2 cert)
        {
            var certificate = new SSLCertificate
            {
                Hostname = cert.GetNameInfo(X509NameType.SimpleName, false),
                FriendlyName = cert.FriendlyName,
                CSRLength = Convert.ToInt32(cert.PublicKey.Key.KeySize.ToString(CultureInfo.InvariantCulture)),
                Installed = true,
                DistinguishedName = cert.Subject,
                Hash = cert.GetCertHash(),
                SerialNumber = cert.SerialNumber,
                ExpiryDate = DateTime.Parse(cert.GetExpirationDateString()),
                ValidFrom = DateTime.Parse(cert.GetEffectiveDateString()),
                Success = true
            };

            return certificate;
        }

        private static bool SiteHasBindingWithDedicatedIp(ServerManager srvman, WebSite website)
        {
            try
            {
                var bindings = srvman.Sites[website.SiteId].Bindings;
                return bindings.Any(b => string.IsNullOrEmpty(b.Host) && b.BindingInformation.Split(':')[1] != "*");
            }
            catch
            {
                return false;
            }
        }
    }
}
