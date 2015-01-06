using System.Globalization;
using Resources.Resource;

namespace WebsitePanel.WebDavPortal.Config.Entities
{
    public class HttpErrorsCollection
    {
        public string this[int statusCode]
        {
            get
            {
                var message = errors.ResourceManager.GetString("_" + statusCode.ToString(CultureInfo.InvariantCulture));
                return message ?? Default;
            }
        }

        public string Default
        {
            get { return errors.Default; }
        }
    }
}