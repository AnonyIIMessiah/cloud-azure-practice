# Week 1

## Topics
- Resource hierarchy (Tenant → Subscription → RG → Resource)
- Microsoft Entra ID, RBAC (Reader/Contributor/Owner)
- Tags, Portal, Cloud Shell, az CLI

## 1. Core Concepts & Why They Exist
| Topic                  | Short Description |
|------------------------|-------------------------------|
| Tenant (Entra ID)      | Top isolation boundary (one directory per customer) |
| Subscription           | Billing + quota + policy boundary |
| Management Group       | Governance over many subscriptions |
| Resource Group         | Lifecycle + permission container (no direct AWS equiv) |
| Entra ID               | Cloud identity & authentication |
| Azure RBAC             | Fine-grained authorization |
| Tags                   | Cost allocation & automation |
| Cloud Shell / az CLI   | Browser terminal + scripting |

## Commands 

To get details of locations available for subscription 
```
az account list-locations -o table
```

To create RSG using CLI
```
az group create --name yc-basics-rg-12345 --location centralindia --tags owner=<email> env=lab cost_center=1001
```

To check the all rgs present
```
az group list -o table
``` 

To list resouces in rsg
```
az resource list --resource-group yc-basics-rg-12345 -o table
```

To delete RSG

```
az group delete --name yc-basics-rg-12345
```

### To set default rsg
```
az config set defaults.group=yc-basics-rg-12345 
```

## Access Model Diagram

```
Tenant → Management Groups → Subscriptions → Resource Groups → Resources
```

## RBAC Matrix
| Role            | Can view RG | Can create resources in RG | Can delete RG | Can manage permissions |
|---|---|---|---|---|
| Owner           | Yes         | Yes                        | Yes           | Yes                    |
| Contributor     | Yes         | Yes                        | Yes           | No                     |
| Reader          | Yes         | No                         | No            | No                     |
| Custom Role     | …           | …                          | …             | …                      |