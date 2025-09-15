param name string
param location string = resourceGroup().location
param secretName string

@secure()
param secretValue string
param principalId string
param acaenvname string
param keyvaultdaprname string
param clientid string

resource acaenv 'Microsoft.App/managedEnvironments@2024-03-01' existing = {
  name: acaenvname
}

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location 
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: secretName
  parent: keyvault
  properties: {
    value: secretValue
  }
}

resource secretOfficerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: keyvault
  name: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, secretOfficerRoleDefinition.id)
  properties: {
    roleDefinitionId: secretOfficerRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2024-03-01' = {
  name: keyvaultdaprname
  parent: acaenv
  properties: {
    componentType: 'secretstores.azure.keyvault'
    version: 'v1'
    ignoreErrors: false
    initTimeout: '5s'
    metadata: [
      {
        name: 'vaultName'
        value: name
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
