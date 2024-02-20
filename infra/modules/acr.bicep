param name string
param location string = resourceGroup().location

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location 
  sku: {
    name: 'Basic'
  }
  properties:{
    adminUserEnabled: true
  }
}

output loginserver string = acr.properties.loginServer
