provider "azurerm" {
  version = "=2.98.0"
  features {}
}

variable "resource_group_name" {
  type        = string
}

variable "apim_name" {
  type        = string
}

variable "location_name" {
  type        = string
}

variable "publisher_name" {
  type        = string
}

variable "publisher_email" {
  type        = string
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location_name
}

resource "azurerm_api_management" "example" {
  name                = var.apim_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "example" {
  name                = "example-api"
  resource_group_name = azurerm_resource_group.example.name
  api_management_name = azurerm_api_management.example.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("${path.module}/conference-api.json")
  }
}