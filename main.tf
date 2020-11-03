
# Create a Top Level Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-RG"
  location = var.location
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        resource_group = azurerm_resource_group.rg.name
    }
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "sa" {
    name                        = "hibro${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        uAwesomeAccount = "hibro-Account"
    }
}

module "hibroNet" {
  source = "./modules/moduleNet"

  prefix = var.prefix
  location = azurerm_resource_group.rg.location
  resource_group = azurerm_resource_group.rg.name
}

module "hibroDisk" {
  source = "./modules/moduleDisk"

  prefix = var.prefix
  location = azurerm_resource_group.rg.location
  resource_group = azurerm_resource_group.rg.name
}

module "hibroRemote" {
  source = "git::https://github.com/prexerx/terraform-remote-module.git"

  prefix = var.prefix
  location = azurerm_resource_group.rg.location
  resource_group = azurerm_resource_group.rg.name
  subnet_id = module.hibroNet.subnet_id

  depends_on = [
    azurerm_resource_group.rg
    ]
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "hibro-VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [module.hibroRemote.nic_id]
  primary_network_interface_id = module.hibroRemote.nic_id
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  boot_diagnostics {
    enabled     = var.debug_enable
    storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
  }

  storage_os_disk {
    name              = "${var.prefix}-OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  plan {
    name      = var.os_sku
    publisher = var.os_publisher
    product   = var.os_offer
  }

  storage_data_disk {
    name            = module.hibroDisk.disk_touchMeStorage_name
    managed_disk_id = module.hibroDisk.disk_touchMeStorage_id
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = module.hibroDisk.disk_touchMeStorage_size
    caching         = "ReadOnly"
  }

  storage_data_disk {
    name            = module.hibroDisk.disk_hitMeStorage_name
    managed_disk_id = module.hibroDisk.disk_hitMeStorage_id
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = module.hibroDisk.disk_hitMeStorage_size
    caching         = "ReadWrite"
  }

  os_profile {
    computer_name  = "hibro-VM"
    admin_username = var.admin_username
    # admin_password = var.admin_password # (login with ssh public key)
    custom_data    = data.template_file.hibro_config[0].rendered
  }

  os_profile_linux_config {
    # disable_password_authentication = false # (login with ssh public key)
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.admin_pub_key
    }
  }

  tags = var.tags
}

data "template_file" "hibro_config" {
  count = 1
  template = file("${path.module}/configs/hibro-azure.tmpl.yml")

  vars = {
    hibro_vm_ip_address =  module.hibroRemote.public_ip_address
    others_environment  = "hibro hacker"
  }
}

resource "null_resource" "hibro_config_update" {

  triggers = {
    template_rendered = data.template_file.hibro_config[0].rendered
  }

  connection {
    type = "ssh"
    user = var.admin_username
    # Azure CloudShell Must use Public IP Address to access the VM.
    host = module.hibroRemote.public_ip_address
    # Azure CloudShell SSH Private Key location!
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = data.template_file.hibro_config[0].rendered
    destination = "/tmp/hibro-update"
  }

  provisioner "remote-exec" {
    inline = [
      "whoami && ls /tmp/ -l"
    ]
  }

  depends_on = [azurerm_virtual_machine.vm]
}
