variable "prefix" {
    type = string
    default = "hibro"
}

variable "location" {
    type = string
    default = "westus2"
}

variable "admin_username" {
    type = string
    description = "Administrator user name for virtual machine"
    default = "hibro"
}

variable "admin_password" {
    type = string
    description = "Password must meet Azure complexity requirements"
    default = "Hibro123"
}

variable "admin_pub_key" {
    description = "SSH public key for login"
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCorWm8FA4ovqbqWGQgoQ2QJo+CuFK7Dr8Zujen6iQVCWaWx/2oCGOi4sgpwAt9H5zfXFBag7eXrG9lL4DE3W5GONmcdn4v8fA0AASORu++mUfLBN3YjcQAudRQLlOtVYVaHTRbL2jiXBHuNvZjkrH1EyCKPdAZEPWauGOE4CXtE/e0Qlcb9i/rK7Eqm3b7/BzbUiNUJv1XpLFuJFSR5YugnSzBxkghvsyz4oOsbJ65pwPgwCGI1gsECcQ3WN93REwekOOedIONRlEzbp6KCCWWAf9rFD4E++INQAvmB+Js8X1WxWydeq3NWHMmFNDLRqAuUnyvsVzVwwBSdlNPJVzb"
}

variable "vm_size" {
    type = string
    default = "Standard_DS1_v2"
}

## Debug

variable "debug_enable" {
    type = string
    default = "true"
}

## OS configuration
variable "os_publisher" {
    type = string
}

variable "os_offer" {
    type = string
}

variable "os_sku" {
    type = string
}

variable "os_version" {
    type = string
}

## a map for tags
variable "tags" {
    type = map
    default = {
        hibroTags = "Terraform Demo with Tags"
    }
}
