# Week 4

Storage Type | What it is |Real problem it solves| AWS Equivalent |
|----------------|----------------|-------------------|------------------|
Blob Storage | Object storage (files |  images |  logs |  backups) | Unlimited cheap durable storage for anything | S3
File Share | SMB/NFS file share in the cloud | Lift-and-shift file servers |  shared drives for apps | EFS + FSx
Queue Storage | Simple message queue | Decouple app components |  worker pattern | SQS
Table Storage | NoSQL key-value store (legacy) | Rarely used now — replaced by Cosmos DB | DynamoDB (sort of)

## Redundancy options

Type | Copies | Geography | Survives zone failure? | Survives region failure? 
|--------------|-------------------|-------------|-------------------|----------------|
LRS | 3 | Same zone | No | No 
ZRS | 3 | 3 zones same region | Yes | No 
GRS | 6 | Primary + secondary region | Yes | Yes (read-only secondary) 
GZRS | 6 | 3 zones + secondary region | Yes | Yes (read-only) 

## Commands with BLOB operations log(Proof)

To create a Storage account
```
az storage account create -n testblobstorageyc -g yc-basics-rg-12345 -l centralindia --sku Standard_LRS
```
To create Blob Containter
```
az storage container create --account-name testblobstorageyc --name container-1 --auth-mode login
```
To upload file without sas
```
az storage blob upload --account-name testblobstorageyc --container-name container-1 --name Readme.md --file Readme.md
```
To generate SAS
```
az storage container generate-sas --account-name testblobstorageyc --name container-1 --permissions rwl --expiry 2025-11-15T15:30:00Z --https-only --output table
```
To upload file to blob using SAS
```
az storage blob upload --account-name testblobstorageyc --container-name container-1 \
  --name readme-sas.md \
  --file Readme.md \
  --sas-token "se=2025-11-15T15%3A30%3A00Z&sp=rwl&spr=https&sv=2022-11-02&sr=c&sig=rTANc622lXgzQlq7eNZQcYYPq0MYXcH99QgxLG9ONbk%3D"
```

```
{
  "client_request_id": "cad6c32d-c1fb-11f0-b144-0800278dcb09",
  "content_md5": "GsEUp/ywSyY5qZvIFRkbSg==",
  "date": "2025-11-15T08:19:23+00:00",
  "encryption_key_sha256": null,
  "encryption_scope": null,
  "etag": "\"0x8DE241FAF5C1178\"",
  "lastModified": "2025-11-15T08:19:23+00:00",
  "request_id": "e0141664-c01e-0031-2d08-561fce000000",
  "request_server_encrypted": true,
  "version": "2022-11-02",
  "version_id": null
}
```
  To download a file using sas
  ```
  az storage blob download \
  --account-name testblobstorageyc --container-name container-1 \
  --name readme-sas.md \
  --file Readme.md \
  --sas-token "se=2025-11-15T15%3A30%3A00Z&sp=rwl&spr=https&sv=2022-11-02&sr=c&sig=rTANc622lXgzQlq7eNZQcYYPq0MYXcH99QgxLG9ONbk%3D"
  ```
Logs
```
Alive[############################################################Finished[#############################################################]  100.0000%
{
  "container": "container-1",
  "content": "",
  "contentMd5": null,
  "deleted": false,
  "encryptedMetadata": null,
  "encryptionKeySha256": null,
  "encryptionScope": null,
  "hasLegalHold": null,
  "hasVersionsOnly": null,
  "immutabilityPolicy": {
    "expiryTime": null,
    "policyMode": null
  },
  "isAppendBlobSealed": null,
  "isCurrentVersion": null,
  "lastAccessedOn": null,
  "metadata": {},
  "name": "readme-sas.md",
  "objectReplicationDestinationPolicy": null,
  "objectReplicationSourceProperties": [],
  "properties": {
    "appendBlobCommittedBlockCount": null,
    "blobTier": null,
    "blobTierChangeTime": null,
    "blobTierInferred": null,
    "blobType": "BlockBlob",
    "contentLength": 334,
    "contentRange": "bytes None-None/334",
    "contentSettings": {
      "cacheControl": null,
      "contentDisposition": null,
      "contentEncoding": null,
      "contentLanguage": null,
      "contentMd5": "fd1nYcSCeZT7R3GolqbJlA==",
      "contentType": "text/markdown"
    },
    "copy": {
      "completionTime": null,
      "destinationSnapshot": null,
      "id": null,
      "incrementalCopy": null,
      "progress": null,
      "source": null,
      "status": null,
      "statusDescription": null
    },
    "creationTime": "2025-11-15T08:11:48+00:00",
    "deletedTime": null,
    "etag": "\"0x8DE241EA04599D6\"",
    "lastModified": "2025-11-15T08:11:48+00:00",
    "lease": {
      "duration": null,
      "state": "available",
      "status": "unlocked"
    },
    "pageBlobSequenceNumber": null,
    "pageRanges": null,
    "rehydrationStatus": null,
    "remainingRetentionDays": null,
    "serverEncrypted": true
  },
  "rehydratePriority": null,
  "requestServerEncrypted": true,
  "snapshot": null,
  "tagCount": null,
  "tags": null,
  "versionId": null
}
```


To delete blob
```
az storage blob delete \
  --account-name testblobstorageyc \
  --container-name container-1 \
  --name Readme-sas.md 
```
To delete container
```
az storage container delete \
  --account-name testblobstorageyc \
  --name container-1
```
To delete storage account
```
az storage account delete \
  --name testblobstorageyc \
  --resource-group yc-basics-rg-12345  \
  --yes
```