using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace CPMS_MVC_API.BLogic
{

    public class Utility
    {
        public static string GetEncodedCredentials(string UserName, string Password)
        {
            string mergedCredentials = String.Format("{0}:{1}", UserName, Password);
            byte[] byteCredentials = Encoding.UTF8.GetBytes(mergedCredentials);
            return Convert.ToBase64String(byteCredentials);
        }
    }
}