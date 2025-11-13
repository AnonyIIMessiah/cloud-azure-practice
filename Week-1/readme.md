# Week 1

To get details of locations available for subscription 
```
az account list-locations -o table
```

To create RSG using CLI
```
az group create --name yc-basics-rg-12345 --location centralindia --tags owner=aman.verma@rsystems.com env=lab cost_center=1001
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