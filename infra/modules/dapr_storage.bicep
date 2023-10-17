param name string
param acaenvname string
param saaccountkey string
param saname string
param sasharename string

resource acaenv 'Microsoft.App/managedEnvironments@2023-05-02-preview' existing = {
  name: acaenvname
}

resource dapr_storage 'Microsoft.App/managedEnvironments/storages@2023-05-01' = {
  name: name
  parent: acaenv
  properties: {
    azureFile: {
      accessMode: 'ReadWrite'
      accountKey: saaccountkey
      accountName: saname
      shareName: sasharename
    }
  }
}
