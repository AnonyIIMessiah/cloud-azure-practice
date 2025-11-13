# Week 2

To create a vnet with network prefix 10.10.0.0/16
```
az network vnet create --name yc-vnet --resource-group yc-basics-rg-12345  --address-prefixes 10.10.0.0/16 
```

To create subnet
```
az network vnet subnet create --name web --vnet-name yc-vnet --resource-group yc-basics-rg-12345 --address-prefixes 10.10.1.0/24
```

To create nsg
```
az network nsg create --resource-group yc-basics-rg-12345 --name web-nsg
```

To create nsg rule
```
az network nsg rule create --resource-group yc-basics-rg-12345 --nsg-name web-nsg --name Allow-HTTP --priority 100 --direction Inbound --source-address-prefixes Internet --destination-port-ranges 80 --access Allow --protocol Tcp
  ```

To associate NSG to subnet
```
az network vnet subnet update --resource-group yc-basics-rg-12345 --vnet-name yc-vnet --name web --network-security-group web-nsg
```
