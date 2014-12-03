using Ninject.Activation;
using WebsitePanel.WebDavPortal.Config;
using WebsitePanel.WebDavPortal.Cryptography;

namespace WebsitePanel.WebDavPortal.DependencyInjection
{
    public class Rfc2898CryptographyProvider : Provider<Rfc2898Cryptography>
    {
        protected override Rfc2898Cryptography CreateInstance(IContext context)
        {
            var rfc2898Cryptography =
                new Rfc2898Cryptography(WebDavAppConfigManager.Instance.Rfc2898CryptographyParameters.PasswordHash,
                                        WebDavAppConfigManager.Instance.Rfc2898CryptographyParameters.SaltKey,
                                        WebDavAppConfigManager.Instance.Rfc2898CryptographyParameters.VIKey);

            return rfc2898Cryptography;
        }
    }
}