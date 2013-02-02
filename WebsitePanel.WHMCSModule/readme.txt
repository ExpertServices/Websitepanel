Extract the "includes" and "modules" directories into the root of your WHMCS installation
Overwrite any files that already exists

To enable addon automation...
1. WHMCS Admin -> Setup -> Addon Modules -> "WebsitePanel Addons Automation" -> Activate
2. Select "Configure"
3. Enter your WebsitePanel Enterprise Server details
4. WHMCS Admin -> Addons -> "WebsitePanel Addons"
5. Enter your addons here. You can get the WHMCS addon ID by clicking the edit icon on the addon and extracting the &id=x from the URL (x being the WHMCS Addon ID)
   You can retrieve your WebsitePanel addon ID by editing the addon and extracting the PlanID=x from the URL (x being the WebsitePanel Addon ID)
6. If this is a Dedicated IP address addon, check the Dedicated IP Address box to allow the module to auto-allocate an IP address.

What does not work?
- Quantities, only a single addon => addon can be allocated
- Terminating / Suspending Addons, I've ran out of time on what I can do currently
- When an IP address is allocated, WebsitePanel does not return back what IP was allocated, so WHMCS is not updated with which IP was assigned to the users hosting space
- A single user => single package is the only way the WebsitePanel server module works. I have no plans on making this work any other way.

DO NOT CONTACT WHMCS FOR SUPPORT WITH THIS MODULE - THIS IS NOT DEVELOPED BY WHMCS AND HAS NO AFFILIATION WITH WHMCS OR WHMCS.COM.