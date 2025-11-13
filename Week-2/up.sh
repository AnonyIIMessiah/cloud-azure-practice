#!/bin/bash
az group create --name yc-basics-rg-12345 --location centralindia --tags owner=aman.verma@rsystems.com env=lab cost_center=1001


az network vnet create --name yc-vnet --resource-group yc-basics-rg-12345  --address-prefixes 10.10.0.0/16 

az network vnet subnet create --name web --vnet-name yc-vnet --resource-group yc-basics-rg-12345 --address-prefixes 10.10.1.0/24
az network vnet subnet create   --resource-group yc-basics-rg-12345   --vnet-name yc-vnet   --name data   --address-prefixes 10.10.2.0/24


az network nsg create --resource-group yc-basics-rg-12345 --name web-nsg

az network nsg rule create --resource-group yc-basics-rg-12345 --nsg-name web-nsg --name Allow-HTTP --priority 100 --direction Inbound --source-address-prefixes Internet --destination-port-ranges 80 --access Allow --protocol Tcp
az network nsg rule create   --resource-group yc-basics-rg-12345   --nsg-name web-nsg   --name Allow-SSH   --priority 110   --direction Inbound   --source-address-prefixes Internet   --destination-port-ranges 22   --access Allow   --protocol Tcp
az network vnet subnet update --resource-group yc-basics-rg-12345 --vnet-name yc-vnet --name web --network-security-group web-nsg

az network vnet subnet show   --resource-group yc-basics-rg-12345   --vnet-name yc-vnet   --name web   --query "networkSecurityGroup.id" -o tsv