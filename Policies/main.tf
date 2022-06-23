#Azure Arc-anbled servers

resource "azurerm_subscription_policy_assignment" "auditArcWindows" {
    name = "auditArcWindows"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0367cfc4-90b3-46ba-a8a6-ddd5d3514878"
    description = "Install the Azure Security agent on your Windows Arc machines in order to monitor your machines for security configurations and vulnerabilities. Results of the assessments can seen and managed in Azure Security Center."
    display_name = "Azure Security agent should be installed on your Windows Arc machines"
}


resource "azurerm_subscription_policy_assignment" "Updates" {
    name = "Updates"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bd876905-5b84-4f73-ab2d-2e7a7c4568d9"
    description = "To ensure periodic assessments for missing system updates are triggered automatically every 24 hours, the AssessmentMode property should be set to 'AutomaticByPlatform'. Learn more about AssessmentMode property for Windows: https://aka.ms/computevm-windowspatchassessmentmode, for Linux: https://aka.ms/computevm-linuxpatchassessmentmode."
    display_name = "Machines should be configured to periodically check for missing system updates"
}
resource "azurerm_subscription_policy_assignment" "passwordAge" {
    name = "passwordAge"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4ceb8dc2-559c-478b-a15b-733fbf1e3738"
    description = "Requires that prerequisites are deployed to the policy assignment scope. For details, visit https://aka.ms/gcpol. Machines are non-compliant if Windows machines that do not have a maximum password age of 70 days"
    display_name = "Audit Windows machines that do not have a maximum password age of 70 days"
}
resource "azurerm_subscription_policy_assignment" "passwordComplexity" {
    name = "passwordComplexity"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bf16e0bb-31e1-4646-8202-60a235cc7e74"
    description = "Requires that prerequisites are deployed to the policy assignment scope. For details, visit https://aka.ms/gcpol. Machines are non-compliant if Windows machines that do not have the password complexity setting enabled"
    display_name = "Audit Windows machines that do not have the password complexity setting enabled"
}

#Azure Arc-anbled SQL-server

resource "azurerm_subscription_policy_assignment" "SQLvulnerability" {
    name = "SQLvulnerability"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6ba6d016-e7c3-4842-b8f2-4992ebc0d72d"
    description = "SQL vulnerability assessment scans your database for security vulnerabilities, and exposes any deviations from best practices such as misconfigurations, excessive permissions, and unprotected sensitive data. Resolving the vulnerabilities found can greatly improve your database security posture."
    display_name = "SQL servers on machines should have vulnerability findings resolved"
}
# Azure Arc-anabled Kubernetes
resource "azurerm_subscription_policy_assignment" "KubernetesDefender" {
    name = "KubernetesDefender"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/8dfab9c4-fe7b-49ad-85e4-1e9be085358f"
    description = "Azure Defender's extension for Azure Arc provides threat protection for your Arc enabled Kubernetes clusters. The extension collects data from nodes in the cluster and sends it to the Azure Defender for Kubernetes backend in the cloud for further analysis. Learn more in https://docs.microsoft.com/azure/security-center/defender-for-kubernetes-azure-arc."
    display_name = "Azure Arc enabled Kubernetes clusters should have Azure Defender's extension installed"
}
resource "azurerm_subscription_policy_assignment" "KubernetesPolicy" {
    name = "KubernetesPolicy"
    subscription_id = "/subscriptions/Your subscription"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6b2122c1-8120-4ff5-801b-17625a355590"
    description = "The Azure Policy extension for Azure Arc provides at-scale enforcements and safeguards on your Arc enabled Kubernetes clusters in a centralized, consistent manner. Learn more at https://aka.ms/akspolicydoc."
    display_name = "Azure Arc enabled Kubernetes clusters should have the Azure Policy extension installed"
}









