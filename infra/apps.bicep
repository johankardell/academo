targetScope = 'resourceGroup'

param location string = resourceGroup().location
param acrname string
param storageName string
param storagedaprname string
param kvname string
param kvdaprname string
param acaEnvName string
param ainame string
param secretname string

@secure()
param secretvalue string

resource aca_env 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: acaEnvName
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrname
}

resource appinsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: ainame
}

resource acaexternalid 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: 'mi-aca-external'
  location: location
}

resource acainternalid 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: 'mi-aca-internal'
  location: location
}

module acrRbacExternal 'modules/acrRbac.bicep' = {
  name: 'acrRbacExternal'
  params: {
    acrname: acrname
    principalId: acaexternalid.properties.principalId
  }
}

module acrRbacInternal 'modules/acrRbac.bicep' = {
  name: 'acrRbacInternal'
  params: {
    acrname: acrname
    principalId: acainternalid.properties.principalId
  }
}

module storageaccount 'modules/storageaccount.bicep' = {
  name: storageName
  params: {
    location: location
    name: storageName
    acaenvname: aca_env.name
    principalId: acainternalid.properties.principalId
    storagedaprname: storagedaprname
    clientid: acainternalid.properties.clientId
  }
}

module keyvault 'modules/keyvault.bicep' = {
  name: 'kv-aca-demo'
  params: {
    location: location
    name: kvname
    acaenvname: aca_env.name
    secretName: secretname
    secretValue: secretvalue
    principalId: acainternalid.properties.principalId
    keyvaultdaprname: kvdaprname
    clientid: acainternalid.properties.clientId
  }
}

module internalapi 'modules/app_internal.bicep' = {
  name: 'internalapi'
  params: {
    uaid: acainternalid.id
    aca_env_id: aca_env.id
    acrloginserver: acr.properties.loginServer
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
    uaid: acaexternalid.id
    aca_env_id: aca_env.id
    acrloginserver: acr.properties.loginServer
    containerName: 'externalapi'
    image: 'acrjkacademo.azurecr.io/externalapi:0.6'
    location: location
    name: 'externalapi'
    aiconnectionstring: appinsights.properties.ConnectionString
  }
}
