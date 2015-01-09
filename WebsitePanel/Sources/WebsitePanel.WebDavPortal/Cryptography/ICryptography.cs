namespace WebsitePanel.WebDavPortal.Cryptography
{
    public interface ICryptography
    {
        string Encrypt(string plainText);
        string Decrypt(string encryptedText);
    }
}