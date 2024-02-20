targetScope = 'resourceGroup'

param location string = resourceGroup().location
param acrname string
param storageName string
param storagedaprname string
param kvname string
param kvdaprname string
param acaEnvName string
param ainame string

resource aca_env 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: acaEnvName
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrname
}

resource appinsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: ainame
}

module storageaccount 'modules/storageaccount.bicep' = {
  name: storageName
  params: {
    location: location
    name: storageName
    acaenvname: aca_env.name
    miClientId: internalapi.outputs.miClientId
    storagedaprname: storagedaprname
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'kv-aca-demo'
  params: {
    location: location
    name: kvname
    acaenvname: aca_env.name
    secretName: 'mysecret'
    secretValue: 'abc123'
    miClientId: internalapi.outputs.miClientId
    keyvaultdaprname: kvdaprname
  }
}

module internalapi 'modules/app_internal.bicep' = {
  name: 'internalapi'
  params: {
    aca_env_id: aca_env.id
    acrname: acrname
    acrloginserver: acr.properties.loginServer
    acrsecret: acr.listCredentials().passwords[0].value
    containerName: 'internalapi'
    image: 'acrjkacademo.azurecr.io/internalapi:0.6'
    location: location
    name: 'internalapi'
    aiconnectionstring: appinsights.properties.ConnectionString
  }
}

module externalapi 'modules/app_external.bicep' = {
  name: 'externalapi'
  params: {
    aca_env_id: aca_env.id
    acrname: acrname
    acrloginserver: acr.properties.loginServer
    acrsecret: acr.listCredentials().passwords[0].value
    containerName: 'externalapi'
    image: 'acrjkacademo.azurecr.io/externalapi:0.6'
    location: location
    name: 'externalapi'
    aiconnectionstring: appinsights.properties.ConnectionString
  }
}
