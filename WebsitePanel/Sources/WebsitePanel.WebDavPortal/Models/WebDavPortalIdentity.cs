using System;
using System.DirectoryServices;
using System.Security.Principal;
using WebsitePanel.WebDavPortal.Constants;

namespace WebsitePanel.WebDavPortal.Models
{
    public class WebDavPortalIdentity
    {
        private readonly DirectoryEntry _dictionaryEntry;
        public IIdentity Identity { get; protected set; }

        public WebDavPortalIdentity(string userName, string password) : this(null, userName, password)
        {
        }

        public WebDavPortalIdentity(string path, string userName, string password)
        {
            _dictionaryEntry = new DirectoryEntry(path, userName, password);
            Identity = new DirectoryIdentity(_dictionaryEntry);
        }

        public object GetADObjectProperty(string name)
        {
            return _dictionaryEntry.Properties.Contains(name) ? _dictionaryEntry.Properties[name][0] : null;
        }

        public string GetOrganizationId()
        {
            const string distinguishedName = "CN=user200000,OU=virt,OU=TESTOU,DC=test,DC=local";
            //string distinguishedName = GetADObjectProperty(DirectoryEntryPropertyNameConstants.DistinguishedName).ToString();

            string[] distinguishedNameParts = distinguishedName.Split(',', '=');
            if (distinguishedNameParts[2] != "OU")
                throw new Exception(@"Problems with parsing 'distinguishedName' DirectoryEntry property");

            return distinguishedNameParts[3];
        }
    }
}