targetScope = 'subscription'

param location string = 'swedencentral'
param acrname string = 'acrjkacademo'
param lawname string = 'lajkacademo'
param envname string = 'acaenvdemo'

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
  name: 'acavnet'
  params: {
    addressPrefix: '192.168.0.0/23' 
    location: location
    name: 'acavnet'
    subnetAddressPrefix: '192.168.0.0/26' 
    subnetName: 'acasubnet'
  }
}

module environment 'modules/environment.bicep' = {
  scope: resourceGroup
  name: envname
  params: {
    laCustomerId: law.outputs.customerId
    laSharedKey: law.outputs.sharedKey
    location: location
    name: envname
    subnetId: vnet.outputs.subnetId
  }
}

module appinsights 'modules/appinsights.bicep' = {
  scope: resourceGroup
  name: 'ai-academo'
  params: {
    location: location
    name: 'ai-academo'
    workspace_id: law.outputs.workspaceId 
  }
}

// --------------------------------------------

module simpleapi 'modules/app_external.bicep' = {
  scope: resourceGroup
  name: 'simpleapi'
  params: {
    aca_env_id: environment.outputs.id
    acrname: acrname
    acrloginserver: acr.outputs.loginserver
    acrsecret: acr.outputs.secret
    containerName: 'externalapi'
    image: 'acrjkacademo.azurecr.io/simpleapi:0.2'
    location: location
    name: 'simpleapi' 
    aiconnectionstring: appinsights.outputs.connectionstring
  }
}

module internalapi 'modules/app_internal.bicep' = {
  scope: resourceGroup
  name: 'internalapi'
  params: {
    aca_env_id: environment.outputs.id
    acrname: acrname
    acrloginserver: acr.outputs.loginserver
    acrsecret: acr.outputs.secret
    containerName: 'internalapi'
    image: 'acrjkacademo.azurecr.io/internalapi:0.1'
    location: location
    name: 'internalapi' 
    aiconnectionstring: appinsights.outputs.connectionstring
  }
}

module externalapi 'modules/app_external.bicep' = {
  scope: resourceGroup
  name: 'externalapi'
  params: {
    aca_env_id: environment.outputs.id
    acrname: acrname
    acrloginserver: acr.outputs.loginserver
    acrsecret: acr.outputs.secret
    containerName: 'externalapi'
    image: 'acrjkacademo.azurecr.io/externalapi:0.4'
    location: location
    name: 'externalapi' 
    aiconnectionstring: appinsights.outputs.connectionstring
  }
}
