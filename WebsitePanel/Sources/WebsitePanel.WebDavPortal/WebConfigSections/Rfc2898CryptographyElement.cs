using System.Configuration;

namespace WebsitePanel.WebDavPortal.WebConfigSections
{
    public class Rfc2898CryptographyElement : ConfigurationElement
    {
        private const string PasswordHashKey = "passwordHash";
        private const string SaltKeyKey = "saltKey";
        private const string ViKeyKey = "VIKey";

        [ConfigurationProperty(PasswordHashKey, IsKey = true, IsRequired = true, DefaultValue = "66640c02dcdec47fb220539c1d47d80da5a98cd9c9fcebc317512db29a947e5c54667a85fdfdecfbde17ab76375bb9309e47025f7bb19a2c5df0c1be039d1c3d")]
        public string PasswordHash
        {
            get { return this[PasswordHashKey].ToString(); }
            set { this[PasswordHashKey] = value; }
        }

        [ConfigurationProperty(SaltKeyKey, IsKey = true, IsRequired = true, DefaultValue = "f4f3397d550320975770be09e8f1510b1971b4876658ebb960a4b2df5b0d95059e8ac2c64eb8c0e0614df93bfbc31ece0f33121fc9c7bc9219db583eab3fee06")]
        public string SaltKey
        {
            get { return this[SaltKeyKey].ToString(); }
            set { this[SaltKeyKey] = value; }
        }

        [ConfigurationProperty(ViKeyKey, IsKey = true, IsRequired = true, DefaultValue = "@1B2c3D4e5F6g7H8")]
        public string VIKey
        {
            get { return this[ViKeyKey].ToString(); }
            set { this[ViKeyKey] = value; }
        }
    }
}