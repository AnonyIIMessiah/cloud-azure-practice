# Week 5


##  Decision Table
| Need                     | Choose                          |  Can stop? | Private networking? |
|--------------------------|----------------------------------|-----------|---------------------|
| .NET + SQL Server skills | Azure SQL Database (Basic)      | No        | Via Private Link    |
| Everything else          | PostgreSQL Flexible Server     | Yes       | Yes by default      |



## Steps to create Azure SQL DB and server using console

1. Create Azure SQL logical server
2. Create Azure DB
3. Add IP in firewall to allow connection
4. Now use sqlcmd to check connectivity

## Commands and Proof

To connect to a db server
```
sqlcmd -S myazuresq.database.windows.net \
       -d mydb \
       -U sqladmin \
       -P "Password" \
       -Q "SELECT DB_NAME();"
```

### Connection Proof
![alt text](image.png)

