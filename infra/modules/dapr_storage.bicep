param name string
param acaenvname string
param saname string
param miClientId string

resource acaenv 'Microsoft.App/managedEnvironments@2023-05-02-preview' existing = {
  name: acaenvname
}

resource daprComponent 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: name
  parent: acaenv
  properties: {
    componentType: 'state.azure.blobstorage'
    version: 'v1'
    ignoreErrors: false
    initTimeout: '5s'
    metadata: [
      {
        name: 'accountName'
        value: saname
      }
      {
        name: 'containerName'
        value: 'academo'
      }
      {
        name: 'azureClientId'
        value: miClientId
      }
    ]
  }
}
