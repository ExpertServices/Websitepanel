using System;

namespace WebsitePanel.WebDav.Core
{
    namespace Client
    {
        public class LockUriTokenPair
        {
            public readonly Uri Href;
            public readonly string lockToken;

            public LockUriTokenPair(Uri href, string lockToken)
            {
            }
        }
    }
}