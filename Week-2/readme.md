# Week 2
## Core Concepts
| Azure          | AWS Equivalent   | Key Difference                                   |
|----------------|------------------|--------------------------------------------------|
| VNet           | VPC              | 1:1                                              |
| Subnet         | Subnet           | 1:1                                              |
| NSG            | Security Group   | NSG = stateless, can apply to subnet OR NIC     |
| Public IP      | Elastic IP       | Standard SKU = zone-redundant                    |
| Load Balancer  | ELB/NLB          | Standard LB required for zones                   |
| NAT Gateway    | NAT Gateway      | Same purpose                                     |

## Commands to create resources
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

## NSG Rules Sheet 
| NSG       | Priority | Name            | Source              | Dest Port | Action | Direction |
|-----------|----------|-----------------|---------------------|-----------|--------|-----------|
| web-nsg   | 100      | AllowHttpSsh    | Internet            | 80,22     | Allow  | Inbound   |
| data-nsg  | 90       | AllowWebTier    | 10.10.1.0/24        | *         | Allow  | Inbound   |
| data-nsg  | 100      | DenyInternet    | Internet            | *         | Deny   | Inbound   |

## Research

NSG = cheap, L4, stateless → use for tier isolation
Azure Firewall = expensive, L7, stateful, centralized
NAT Gateway → clean outbound IPs (no random SNAT)