using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;
using System.Web.Routing;
using WebsitePanel.WebDav.Core;

namespace WebsitePanel.WebDavPortal.CustomAttributes
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
    public class UniqueAdPhoneNumberAttribute : RemoteAttribute
    {

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            Type type = Assembly.GetExecutingAssembly()
                .GetTypes()
                .FirstOrDefault(validationtype => validationtype.Name == string.Format("{0}controller", this.RouteData["controller"].ToString()));

            object response = null;

            if (type != null)
            {
                MethodInfo method = type.GetMethods()
                    .FirstOrDefault(callingMethod => callingMethod.Name.ToLower() == (string.Format("{0}", this.RouteData["action"]).ToString().ToLower()));

                if (method != null)
                {
                    object instance = Activator.CreateInstance(type);
                    response = method.Invoke(instance, new [] { value });
                }
            }

            if (response is bool)
            {
                var attributes =
                    validationContext.ObjectType.GetProperty(validationContext.MemberName)
                        .GetCustomAttributes(typeof(DisplayNameAttribute), true);

                string displayName = attributes != null && attributes.Any()
                    ? (attributes[0] as DisplayNameAttribute).DisplayName
                    : validationContext.DisplayName;


                return (bool)response ? ValidationResult.Success :
                       new ValidationResult(string.Format(Resources.Messages.AlreadyInUse, displayName));
            }

            return ValidationResult.Success; 
        }

        public UniqueAdPhoneNumberAttribute(string routeName) : base(routeName) { }
        public UniqueAdPhoneNumberAttribute(string action, string controller) : base(action, controller) { }
        public UniqueAdPhoneNumberAttribute(string action, string controller, 
               string area) : base(action, controller, area) { }
    }
}