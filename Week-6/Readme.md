# Week 6

To get secret using CLI
```
az keyvault secret show --vault-name yckeyvaultyc --name db-conn-string --query "value" -o tsv
```

Output
```                      
"Server=tcp:myazuresq.database.windows.net,1433;Initial Catalog=mydb;Persist Security Info=False;User ID=sqladmin;Password=****;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
```

### Recommended Access Pattern (2025 Production)

┌─────────────────────┐      ┌─────────────────────┐
│   App Service / VM  │      │   Key Vault         │
│   (Managed Identity)│─────>│   RBAC: Secrets User│
└─────────────────────┘      └─────────────────────┘

Never use:
- Account keys
- SAS tokens for DBs
- Hard-coded connection strings
- Access policies (legacy)

Always use:
- Key Vault with RBAC enabled
- System-assigned or User-assigned Managed Identity
- "Key Vault Secrets User" role (read-only) for apps