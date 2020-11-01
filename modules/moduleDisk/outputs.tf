output "disk_touchMeStorage_name" {
    value = azurerm_managed_disk.touchMeStorage.name
}

output "disk_touchMeStorage_id" {
    value = azurerm_managed_disk.touchMeStorage.id
}

output "disk_touchMeStorage_size"{
    value = azurerm_managed_disk.touchMeStorage.disk_size_gb
}


output "disk_hitMeStorage_name" {
    value = azurerm_managed_disk.hitMeStorage.name
}

output "disk_hitMeStorage_id" {
    value = azurerm_managed_disk.hitMeStorage.id
}

output "disk_hitMeStorage_size"{
    value = azurerm_managed_disk.hitMeStorage.disk_size_gb
}