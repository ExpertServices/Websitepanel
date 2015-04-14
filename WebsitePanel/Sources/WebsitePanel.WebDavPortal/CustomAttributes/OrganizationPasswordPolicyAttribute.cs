using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsitePanel.Providers.HostedSolution;
using WebsitePanel.WebDav.Core;
using WebsitePanel.WebDav.Core.Config;

namespace WebsitePanel.WebDavPortal.CustomAttributes
{
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = false, Inherited = false)]
    public class OrganizationPasswordPolicyAttribute : ValidationAttribute, IClientValidatable
    {
        public OrganizationPasswordSettings Settings { get; private set; }

        public OrganizationPasswordPolicyAttribute()
        {
            int itemId = -1;

            if (WspContext.User != null)
            {
                itemId = WspContext.User.ItemId;
            }
            else if (HttpContext.Current != null && HttpContext.Current.Session[WebDavAppConfigManager.Instance.SessionKeys.ItemId] != null)
            {
                itemId = (int) HttpContext.Current.Session[WebDavAppConfigManager.Instance.SessionKeys.ItemId];
            }


            Settings = WspContext.Services.Organizations.GetOrganizationPasswordSettings(itemId);
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value != null)
            {
                var resultMessages = new List<string>();

                if (Settings != null)
                {
                    var valueString = value.ToString();

                    if (valueString.Length < Settings.MinimumLength)
                    {
                        resultMessages.Add(string.Format(Resources.Messages.PasswordMinLengthFormat,
                            Settings.MinimumLength));
                    }

                    if (valueString.Length > Settings.MaximumLength)
                    {
                        resultMessages.Add(string.Format(Resources.Messages.PasswordMaxLengthFormat,
                            Settings.MaximumLength));
                    }

                    if (Settings.PasswordComplexityEnabled)
                    {
                        var symbolsCount = valueString.Count(Char.IsSymbol);
                        var numbersCount = valueString.Count(Char.IsDigit);
                        var upperLetterCount = valueString.Count(Char.IsUpper);

                        if (upperLetterCount < Settings.UppercaseLettersCount)
                        {
                            resultMessages.Add(string.Format(Resources.Messages.PasswordUppercaseCountFormat,
                                Settings.UppercaseLettersCount));
                        }

                        if (numbersCount < Settings.NumbersCount)
                        {
                            resultMessages.Add(string.Format(Resources.Messages.PasswordNumbersCountFormat,
                                Settings.NumbersCount));
                        }

                        if (symbolsCount < Settings.SymbolsCount)
                        {
                            resultMessages.Add(string.Format(Resources.Messages.PasswordSymbolsCountFormat,
                                Settings.SymbolsCount));
                        }
                    }

                }

                return resultMessages.Any()?  new ValidationResult(string.Join("<br>", resultMessages)) : ValidationResult.Success;
            }

            return ValidationResult.Success;
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule();

            rule.ErrorMessage = string.Format(Resources.Messages.PasswordMinLengthFormat, Settings.MinimumLength);
            rule.ValidationParameters.Add("count", Settings.MinimumLength);
            rule.ValidationType = "minimumlength";

            yield return rule;

            rule = new ModelClientValidationRule();

            rule.ErrorMessage = string.Format(Resources.Messages.PasswordMaxLengthFormat, Settings.MaximumLength);
            rule.ValidationParameters.Add("count", Settings.MaximumLength);
            rule.ValidationType = "maximumlength";

            yield return rule;

            if (Settings.PasswordComplexityEnabled)
            {
                rule = new ModelClientValidationRule();

                rule.ErrorMessage = string.Format(Resources.Messages.PasswordUppercaseCountFormat, Settings.UppercaseLettersCount);
                rule.ValidationParameters.Add("count", Settings.UppercaseLettersCount);
                rule.ValidationType = "uppercasecount";

                yield return rule;

                rule = new ModelClientValidationRule();

                rule.ErrorMessage = string.Format(Resources.Messages.PasswordNumbersCountFormat, Settings.NumbersCount);
                rule.ValidationParameters.Add("count", Settings.NumbersCount);
                rule.ValidationType = "numberscount";

                yield return rule;

                rule = new ModelClientValidationRule();

                rule.ErrorMessage = string.Format(Resources.Messages.PasswordSymbolsCountFormat, Settings.SymbolsCount);
                rule.ValidationParameters.Add("count", Settings.SymbolsCount);
                rule.ValidationType = "symbolscount";

                yield return rule;
            }
        }

    }
}