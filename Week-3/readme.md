# Week 3

To create a public IP
```
az network public-ip create --resource-group yc-basics-rg-12345 --name vm-web-ip --dns-name yc-week3-vm --allocation-method Static --sku Standard
```
To create NIC
```
az network nic create \
  --resource-group yc-basics-rg-12345 \
  --name vm-web-nic \
  --vnet-name yc-vnet \
  --subnet web \
  --public-ip-address vm-web-ip \
  --network-security-group web-nsg
  ```
To create a vm
```
az vm create \
  --resource-group yc-basics-rg-12345 \
  --name yc-web-vm \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --nics vm-web-nic \
  --admin-username azureuser \
  --generate-ssh-keys \
  --custom-data cloud-init.sh
```

**Link**: http://yc-week3-vm.centralindia.cloudapp.azure.com/

# Compute Choice Decision Note

| Criteria | VM | App Service | Container Apps |
|--------|----|-------------|----------------|
| **Setup Time** | 15 min | 3 min | 10 min |
| **Ops Burden** | High (patch, scale) | Low | Medium |
| **Scale-Out** | Manual/VMSS | Auto | Auto |
| **Custom OS** | Yes | No | No |
| **Cost (B1s equiv)** | ~$13/mo | ~$13/mo (B1) | ~$20/mo |
| **Best For** | Legacy, full control | Standard web apps | Docker, microservices |

