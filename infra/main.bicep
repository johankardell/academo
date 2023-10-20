targetScope = 'subscription'

param location string = 'swedencentral'
param acrname string = 'acrjkacademo'
param lawname string = 'lajkacademo'
param envname string = 'acaenvdemo'
param vnetname string = 'acavnet'
param storageName string = 'stjkacademo'
param storagedaprname string = 'mystorage'
param ainame string = 'ai-academo'
param kvname string = 'kv-aca-demo231019'
param kvdaprname string = 'mysecretstore'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-aca-demo'
  location: location
}

module acr 'modules/acr.bicep' = {
  scope: resourceGroup
  name: acrname
  params: {
    location: location
    name: acrname
  }
}

module law 'modules/loganalytics.bicep' = {
  scope: resourceGroup
  name: lawname
  params: {
    location: location
    name: lawname
  }
}

module vnet 'modules/vnet.bicep' = {
  scope: resourceGroup
  name: vnetname
  params: {
    addressPrefix: '192.168.0.0/23'
    location: location
    name: vnetname
    subnetAddressPrefix: '192.168.0.0/26'
    subnetName: 'acasubnet'
  }
}

module aca_env 'modules/aca_environment.bicep' = {
  scope: resourceGroup
  name: envname
  params: {
    laCustomerId: law.outputs.customerId
    laSharedKey: law.outputs.sharedKey
    location: location
    name: envname
    subnetId: vnet.outputs.subnetId
    aiconnectionstring: appinsights.outputs.connectionstring
    aiinstrumentationkey: appinsights.outputs.instrumentationkey
  }
}

module appinsights 'modules/appinsights.bicep' = {
  scope: resourceGroup
  name: ainame
  params: {
    location: location
    name: ainame
    workspace_id: law.outputs.workspaceId
  }
}

module storageaccount 'modules/storageaccount.bicep' = {
  scope: resourceGroup
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
  scope: resourceGroup
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

// --------------------------------------------

module internalapi 'modules/app_internal.bicep' = {
  scope: resourceGroup
  name: 'internalapi'
  params: {
    aca_env_id: aca_env.outputs.id
    acrname: acrname
    acrloginserver: acr.outputs.loginserver
    acrsecret: acr.outputs.secret
    containerName: 'internalapi'
    image: 'acrjkacademo.azurecr.io/internalapi:0.20'
    location: location
    name: 'internalapi'
    aiconnectionstring: appinsights.outputs.connectionstring
  }
}

module externalapi 'modules/app_external.bicep' = {
  scope: resourceGroup
  name: 'externalapi'
  params: {
    aca_env_id: aca_env.outputs.id
    acrname: acrname
    acrloginserver: acr.outputs.loginserver
    acrsecret: acr.outputs.secret
    containerName: 'externalapi'
    image: 'acrjkacademo.azurecr.io/externalapi:0.20'
    location: location
    name: 'externalapi'
    aiconnectionstring: appinsights.outputs.connectionstring
  }
}
