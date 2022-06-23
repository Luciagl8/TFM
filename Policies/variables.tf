variable "subscription" {
    default = "/subscriptions/Your subscription"
}
variable "group1"{
    default = "/subscriptions/Your subscription/resourceGroups/{resourceGroupName}"
}
variable "resource1"{
    default = "/subscriptions/Your subscription/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/[{parentResourcePath}/]"
}