param name string
param location string = resourceGroup().location
param principalId string
param acaenvname string
param storagedaprname string
param clientid string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Enabled'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
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

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: sa
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, principalId, contributorRoleDefinition.id)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource acaenv 'Microsoft.App/managedEnvironments@2023-05-02-preview' existing = {
  name: acaenvname
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: storagedaprname
  parent: acaenv
  properties: {
    componentType: 'state.azure.blobstorage'
    version: 'v1'
    ignoreErrors: false
    initTimeout: '5s'
    metadata: [
      {
        name: 'accountName'
        value: name
      }
      {
        name: 'containerName'
        value: 'academo'
      }
      {
        name: 'azureClientId'
        value: clientid
      }
    ]
    scopes: [
      'internalapi'
    ]
  }
}


output accesskey string = sa.listKeys().keys[0].value
output filesharename string = fileshare.name
