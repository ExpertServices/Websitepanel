using System;
using System.Runtime.Serialization;

namespace WebsitePanel.WebDavPortal.Exceptions
{
    [Serializable]
    public class ConnectToWebDavServerException : Exception
    {
        public ConnectToWebDavServerException()
        {
        }

        public ConnectToWebDavServerException(string message) : base(message)
        {
        }

        public ConnectToWebDavServerException(string message, Exception inner) : base(message, inner)
        {
        }

        protected ConnectToWebDavServerException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}