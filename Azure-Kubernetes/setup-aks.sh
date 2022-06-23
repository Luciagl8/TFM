#!/bin/bash
# AKS
K8S_CLUSTER_RG_NAME="k8AKS-RG"
K8S_CLUSTER_NAME="k8AKS-c$RANDOM"
LOCATION="eastus"

# AKS-ARC
K8S_ARC_PREFIX="k8Arc"
ARC_RG_NAME="${K8S_ARC_PREFIX}-RG"
ARC_CLUSTER_NAME="${K8S_ARC_PREFIX}-cluster"


#Habilitación de todos los proveedores de recursos necesarios
az feature register --namespace Microsoft.Kubernetes --name previewAccess
az provider register --namespace Microsoft.Kubernetes --wait

az feature register --namespace Microsoft.KubernetesConfiguration --name extensions
az provider register --namespace Microsoft.KubernetesConfiguration --wait

az feature register --namespace Microsoft.ExtendedLocation --name CustomLocations-ppauto
az provider register --namespace Microsoft.ExtendedLocation --wait

az provider register --namespace Microsoft.Web --wait
az provider show -n Microsoft.Web --query "resourceTypes[?resourceType=='kubeEnvironments'].locations"

#Instalación de las extensions necesarias
echo "Installing extensions needed..."
az extension add --upgrade --yes -n connectedk8s
az extension add --upgrade --yes -n customlocation
az extension add --yes --source "https://aka.ms/appsvc/appservice_kube-latest-py2.py3-none-any.whl"
az extension add --upgrade --yes -n k8s-extension
az extension add --upgrade --yes -n k8s-configuration

# create AKS cluster
####################
az group create -l $LOCATION -n $K8S_CLUSTER_RG_NAME
echo "Resource group created"
az aks create -g $K8S_CLUSTER_RG_NAME -n $K8S_CLUSTER_NAME --generate-ssh-keys --node-count 1
echo "Kubernetes cluster created"

#Para autenticarnos en el cli
echo "Authenticating..."
az aks get-credentials -g $K8S_CLUSTER_RG_NAME -n $K8S_CLUSTER_NAME
kubectl get ns


#########################Conexion azure ARC
#Creación grupo de recursos azure arc
echo "Adding cluster to Azure-Arc..."
az group create -n $ARC_RG_NAME -l $LOCATION
az provider show -n Microsoft.Kubernetes --query "[registrationState,resourceTypes[?resourceType=='connectedClusters'].locations]"
az connectedk8s connect -n $ARC_CLUSTER_NAME -g $ARC_RG_NAME 

kubectl get pods -n azure-arc
echo "Check if the output includes pods of clusterconnect-agent"


# #Crea un espacio de tabajo de Log Analytics
echo "Creating Log Analytics workspace"
az k8s-extension create --name azuremonitor-containers --cluster-name $ARC_CLUSTER_NAME --resource-group $ARC_RG_NAME --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers


echo "Enabling Azure Policy..."
az provider register --namespace 'Microsoft.PolicyInsights'
az k8s-extension create --cluster-type connectedClusters --cluster-name $ARC_CLUSTER_NAME --resource-group $ARC_RG_NAME --extension-type Microsoft.PolicyInsights --name azurepolicy


#APLICACION CON GITOPS

appClonedRepo='https://github.com/Luciagl8/HelloWorld.git'

# Create a namespace for your ingress resources
kubectl create ns cluster-mgmt

# Add the official stable repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Use Helm to deploy an NGINX ingress controllery
helm install nginx ingress-nginx/ingress-nginx -n cluster-mgmt

kubectl create ns hello-arc

az k8s-configuration create \
--cluster-name $ARC_CLUSTER_NAME \
--resource-group $ARC_RG_NAME \
--name cluster-config \
--operator-instance-name cluster-config --operator-namespace cluster-config \
--repository-url $appClonedRepo \
--scope cluster --cluster-type connectedClusters \
--operator-params="--git-poll-interval 3s --git-readonly"

echo "Arc cluster with GitOps installed finished"
