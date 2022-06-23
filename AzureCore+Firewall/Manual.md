1. Run the next commands:
    >>> terraform init
    >>> terraform apply
(If it fails after deploying the virtual network gateways, run again the command terraform apply)
2. Run the next command in Azure Portal Powershell to install the web service extension in spoke VM
    >>> Set-AzVMExtension `
        -ResourceGroupName azure-core-rg `
        -ExtensionName IIS `
        -VMName VM-Spoke `
        -Publisher Microsoft.Compute `
        -ExtensionType CustomScriptExtension `
        -TypeHandlerVersion 1.4 `
        -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server"}' `
        -Location EastUS

# Prepare an Azure VM for Azure Arc-enabled servers
1. Remove any VM extensions on the On-prem VM
2. Disable the Azure VM Guest Agent
    - Connect to on-prem VM via RDP
    - Run the next commands in Powershell
        >>> Set-Service WindowsAzureGuestAgent -StartupType Disabled -Verbose
        >>> Stop-Service WindowsAzureGuestAgent -Force -Verbose
        >>> New-NetFirewallRule -Name BlockAzureIMDS -DisplayName "Block access to Azure IMDS" -Enabled True -Profile Any -Direction Outbound -Action Block -RemoteAddress 169.254.169.254
3. Download the script to connect the VM to Azure Arc
    - In Azure Portal go to Azure Arc > Add > Servers and select Generate script
    - Select the resurce group you want, the region, the operating system (Windows) and the connectivity method (Public Endpoint) and download the script
4. Connect to the on-prem VM via RDP and execute the downloaded script in the powershell
