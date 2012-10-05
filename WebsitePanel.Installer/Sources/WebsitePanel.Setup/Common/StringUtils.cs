using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace WebsitePanel.Setup.Common
{
    public class StringUtils
    {
        public static string GenerateRandomString(int length)
        {
            RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider();
            byte[] data = new byte[length];
            crypto.GetNonZeroBytes(data);
            return BitConverter.ToString(data).Replace("-", "").ToLowerInvariant();
        }
    }
}
