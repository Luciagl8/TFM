resource "azurerm_resource_group" "shell-storage" {
  name     = "shell-storage"
  location = "eastus"
}
data "azurerm_client_config" "current" {}
resource "azurerm_storage_account" "shell-storage-account" {
  name                     = "shell18927367748"
  resource_group_name      = azurerm_resource_group.shell-storage.name
  location                 = azurerm_resource_group.shell-storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
 identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_key_vault_key" "generated" {
  name         = "key1"
  key_vault_id = azurerm_key_vault.key-vault-storage.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_key_vault_access_policy.storage
  ]
}
resource "azurerm_key_vault" "key-vault-storage" {
  name                = "kvshell"
  location            = azurerm_resource_group.shell-storage.location
  resource_group_name = azurerm_resource_group.shell-storage.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  purge_protection_enabled        = true
}
resource "azurerm_storage_account_customer_managed_key" "this" {
 storage_account_id = azurerm_storage_account.shell-storage-account.id
 key_vault_id = azurerm_key_vault.key-vault-storage.id
 key_name = azurerm_key_vault_key.generated.name
 depends_on = [
    azurerm_key_vault_access_policy.storage
 ]
}
resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = azurerm_key_vault.key-vault-storage.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.shell-storage-account.identity.0.principal_id

  key_permissions    = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
  secret_permissions = ["Get"]
}