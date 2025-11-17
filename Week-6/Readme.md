# Week 6

To get secret using CLI
```
az keyvault secret show --vault-name yckeyvaultyc --name db-conn-string --query "value" -o tsv
```

Output
```                      
"Server=tcp:myazuresq.database.windows.net,1433;Initial Catalog=mydb;Persist Security Info=False;User ID=sqladmin;Password=****;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"