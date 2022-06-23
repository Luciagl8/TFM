
# Steps to deploy an Azure SQL server connected to Azure ARC
1. Log in the Azure portal:
    >>> az login
2. Assign a "Contributor role"
    >>> az ad sp create-for-rbac -n "http://AzureArcServers" --role contributor
3. From the output take the appId, password and tenant
4. Registration on the necessary Azure providers (This acction take a while)
    >>> az provider register --namespace Microsoft.AzureArcData
5. Create an AWS user with Programmatic access, attach existing policies directly "AmazonEC2FullAccess"
6. Take note of the Access key ID and Secret access key from the created user
7. Modify variables.tf with the necessary default values
9. Run the next commands:
    >>> terraform init
    >>> terraform apply --auto-approve
10. Connect to the EC2 instance created by RDP
11. Wait until the Logon script is executed on the virtual machine
12. There must be a server and SQL-server conected to azure Arc in Azure Portal

# Install MMA Agent and activate Environmental health
1. Go to Azure Portal, select de Arc-server created -> extensions -> add -> Log analytics and install it
2. (Optional) Install SqlServerArcExtension
2. Go to Arc-SQL server created -> Environment health
3. The MMA must be installed, in the step 2 select domain account and generate the script
4. Copy the script in the machine who has the SQL server
5. Run the next commands in a powershell with administrator rights
    >>> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    >>> & '.\AddSqlAssessment.ps1'
6. It would ask for the user and password, use lucia and ArcPassword123!!
7. The task must be generated
8. Go to Task Scheduler -> libraries -> Microsoft -> Operations Management Suite -> AOI ** -> Assesments select the task and run it.
9. The task scheduler will ask you for the user and password another time
10. Wait 1h to see the data displayed in Azure Portal

