namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class Rfc2898CryptographyParameters : AbstractConfigCollection
    {
        public string PasswordHash { get; private set; }
        public string SaltKey { get; private set; }
        public string VIKey { get; private set; }

        public Rfc2898CryptographyParameters()
        {
            PasswordHash = ConfigSection.Rfc2898Cryptography.PasswordHash;
            SaltKey = ConfigSection.Rfc2898Cryptography.SaltKey;
            VIKey = ConfigSection.Rfc2898Cryptography.VIKey;
        }
    }
}