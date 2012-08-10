Write-Host -ForegroundColor Green "
Ensure that you have created the EnterpriseServer Database
by executing test-createDB.bat and compiled WebsitePanel by
executing build-test.bat .

Configuration:

WebsitePanel Portal:

URL: http://localhost:9001
Login: serveradmin
Password: 1234


WebsitePanel Enterprise Server:
URL: http://localhost:9002
Database Login: WebsitePanel
Database Password: Password12


WebsitePanel Server:
URL: http://localhost:9003
Password: Password12
"

start http://localhost:9001

Read-Host "Press a key"


	
	
	