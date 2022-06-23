
# Steps to deploy an AWS-server with Arc-enabled-servers
1. Log in the Azure portal:
    >>> az login
2. Assign a "Contributor role"
    >>> az account show --query id --output tsv
    >>> az ad sp create-for-rbac -n "ArcAWS" --role "Contributor" --scopes /subscriptions/5d498653-580f-4e59-a2fb-df5c716e2524
3. From the output take the appId, password and tenant
4. Registration on the necessary Azure providers (This acction take a while)
    >>> az provider register --namespace 'Microsoft.HybridCompute'
    >>> az provider register --namespace 'Microsoft.GuestConfiguration'
    >>> az provider register --namespace 'Microsoft.HybridConnectivity'
5. Create an AWS user with Programmatic access, attach existing policies directly "AmazonEC2FullAccess"
6. Take note of the Access key ID and Secret access key from the created user
7. Modify scripts/vars.sh and variables.tf with the necessary values
8. Make sure that the ssh keys are available at ~/.ssh named id_ed25519.pub and id_ed25519
9. Run the next commands
    >>> terraform init
    >>> terraform apply --auto-approve 
10. The instances must be available at AWS and Azure Portal

# Installation of Log Analytics
1. Create the workspace:
    - Introduce the necessary values in ./scripts/log_analytics-template.parameters.json file.
    - Run the next command:
    >>> az deployment group create --resource-group Arc-AWS-Demo --template-file ./scripts/log_analytics-template.json --parameters ./scripts/log_analytics-template.parameters.json 
2. Take the necessary values from the created workspace in the Azure Portal and write them in mma-template-parameters.json file 
3. Run the next command:
    >>> az deployment group create --resource-group Arc-AWS-Demo --template-file ./scripts/mma-template-linux.json --parameters ./scripts/mma-template.parameters.json

# Create a policy
1. Edit the file ./scripts/policy.json with the necessary values
2. Run the next command:
    >>> az policy assignment create --name 'Enable Azure Monitor for VMs' --scope '/subscriptions/your subscription/resourceGroups/Arc-AWS-Demo' --policy-set-definition '55f3eceb-5573-4f18-9695-226972c6d74a' -p ./scripts/policy.json --assign-identity --location westus2
3. Wait 30 min and check if the policy is compliant or not.
4. If is no compilant create a remedation task and remediate it


# Microsoft Defender for cloud
1. Once the Log Analytics workspace is deployed introduce the next command
    >>> az security workspace-setting create --name default --target-workspace '/subscriptions/your subscription/resourceGroups/Arc-AWS-Demo/providers/Microsoft.OperationalInsights/workspaces/Arc-servers'                     
    >>> az security pricing create -n VirtualMachines --tier 'standard'
2. Create a policy with recomendations
    >>> az policy assignment create --name 'ASC Default ' --scope '/subscriptions/your subscription' --policy-set-definition '1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
3. Wait 30 min for the Azure Arc-enabled server to be shown in Microsoft Defender
