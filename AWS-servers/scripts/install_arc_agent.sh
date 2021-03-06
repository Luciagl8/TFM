#!/bin/bash
# Download the installation package
wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh

# Install the hybrid agent
sudo bash ~/install_linux_azcmagent.sh

# Import the config variables set in vars.sh
source /tmp/vars.sh

# Run connect command
sudo azcmagent connect \
  --service-principal-id $TF_VAR_client_id \
  --service-principal-secret $TF_VAR_client_secret \
  --tenant-id $TF_VAR_tenant_id \
  --subscription-id $TF_VAR_subscription_id \
  --location "westus2" \
  --resource-group "Arc-AWS-Demo" \
  --correlation-id "d009f5dd-dba8-4ac7-bac9-b54ef3a6671a"
