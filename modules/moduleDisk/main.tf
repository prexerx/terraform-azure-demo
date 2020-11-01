

resource "azurerm_managed_disk" "touchMeStorage" {
  name                 = "${var.prefix}-touchMe-storage"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Copy"
  source_resource_id   = azurerm_managed_disk.copyMeStorage.id
  disk_size_gb         = "8"
}

resource "azurerm_managed_disk" "hitMeStorage" {
  #count               = 1
  name                 = "${var.prefix}-hitMe-Storage"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "8"
}

# no use, just to be copied, don't export out.
resource "azurerm_managed_disk" "copyMeStorage" {
  name                 = "${var.prefix}-copyMe-Storage"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "8"
}