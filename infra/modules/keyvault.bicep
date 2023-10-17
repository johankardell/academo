param name string
param location string
param secretName string
param secretValue string
param miClientId string

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

// resource secret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
//   name: secretName
//   properties: {
//     value: secretValue
//     contentType: 'text/plain'
//   }
// }

// resource secretOfficerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
//   scope: keyvault
//   name: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
// }

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(resourceGroup().id, secretOfficerRoleDefinition.id)
//   properties: {
//     roleDefinitionId: secretOfficerRoleDefinition.id
//     principalId: miClientId
//     principalType: 'ServicePrincipal'
//   }
// }
