param acrname string
param principalId string
var acrPullRoleDefId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: acrname
}

resource acrRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: acr
  name: guid(principalId, acrPullRoleDefId, acrname)
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleDefId)
  }
}
