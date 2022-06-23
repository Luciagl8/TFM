
# Steps
1. Log in the Azure portal:
    >>> az login
2. From the output take the appId, password and tenant
3. Registration on the necessary Azure providers (This acction take a while)
    >>> az provider register --namespace Microsoft.Kubernetes
    >>> az provider register --namespace Microsoft.KubernetesConfiguration
    >>> az provider register --namespace Microsoft.ExtendedLocation
    >>> az provider register --namespace Microsoft.PolicyInsights
4. Install the necessary Kubernetes CLI extensions
    >>> az extension add --name connectedk8s
    >>> az extension add --name k8s-configuration
    >>> az extension add --name k8s-extension
(If they are installed update them:
    >>> az extension update --name connectedk8s
    >>> az extension update --name k8s-configuration)
6. Take note of the Access key ID and Secret access key and update the file variables.tf
7. Configure the aws CLI with that values
    >>> aws configure
    >>> setx AWS_SECRET_ACCESS_KEY (yours)
    >>> setx AWS_ACCESS_KEY_ID (yours)
8. Run the next commands:
    >>> terraform init
    >>> terraform apply --auto-approve
9. Output the configuration from Terraform into the config file using the next commands:
    >>> mkdir ~/.kube/
    >>> terraform output -raw kubeconfig > ~/.kube/config
10. Check to see if cluster is discoverable by kubectl by running:
    >>> kubectl version
    kubectl config current-context
11. Run the next commands to configure EKS nodes to communicate to EKS Control Plane
    >>> terraform output -raw config_map_aws_auth > configmap.yml
    >>> kubectl apply -f configmap.yml
12. Update the kube config file:
    >>> aws eks --region us-west-2 update-kubeconfig --name arc-eks
13. Create a resource group in azure
    >>> az group create --name AzureArcK8 --location EastUS --output table
14. Connect the cluster to Azure Arc:
    >>> az connectedk8s connect --name AWS-cluster --resource-group AzureArcK8
15. Run the next command to see the datails of the connected cluster
    >>> kubectl -n azure-arc get deployments,pods
16. Extensions
    >>> az k8s-extension create --name azuremonitor-containers --cluster-name AWS-cluster --resource-group AzureArcK8 --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers
    >>> az k8s-extension create --name azurepolicy --cluster-name AWS-cluster --resource-group AzureArcK8 --cluster-type connectedClusters  --extension-type Microsoft.PolicyInsights
    >>>  az k8s-extension create --name azureDefender --cluster-name AWS-cluster --resource-group AzureArcK8 --cluster-type connectedClusters --extension-type Microsoft.AzureDefender.Kubernetes



