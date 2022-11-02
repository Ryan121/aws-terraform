terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.28.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "terraform_az_provider" {
    name = "terraform_az_provider"
    location = "East US"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.terraform_az_provider.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.terraform_az_provider]
}

module "windowsservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.terraform_az_provider.name
  is_windows_image    = true
  vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["winsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_B1ls"
  depends_on = [azurerm_resource_group.terraform_az_provider]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.terraform_az_provider.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.terraform_az_provider]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}
