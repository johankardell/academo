param name string
param location string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Enabled'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

resource fileservices 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  parent: sa
  name: 'default'
}

resource fileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: 'ids'
  parent: fileservices
}

output accesskey string = sa.listKeys().keys[0].value
output filesharename string = fileshare.name
