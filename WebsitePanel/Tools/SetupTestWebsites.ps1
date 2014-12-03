Import-Module WebAdministration

cd ..
$path = pwd
cd Tools

New-Website -Name "WebsitePanel Server" -Port 9003 -PhysicalPath "$path\Sources\WebsitePanel.Server" -ErrorAction SilentlyContinue
New-Website -Name "WebsitePanel Enterprise Server" -Port 9002 -PhysicalPath "$path\Sources\WebsitePanel.EnterpriseServer" -ErrorAction SilentlyContinue
New-Website -Name "WebsitePanel Portal" -Port 9001 -PhysicalPath "$path\Sources\WebsitePanel.WebPortal" -ErrorAction SilentlyContinue
	
	
	