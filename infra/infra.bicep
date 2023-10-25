targetScope = 'subscription'

param location string = 'swedencentral'
param acrname string = 'acrjkacademo'
param lawname string = 'lajkacademo'
param envname string = 'acaenvdemo'
param ainame string = 'ai-academo'
param vnetname string = 'acavnet'
param vnetPrefix string = '192.168.0.0/23'
param acaSubnetName string = 'acasubnet'
param acaSubnetPrefix string = '192.168.0.0/26'
param appgwSubnetName string = 'appgwsubnet'
param appgwSubnetPrefix string = '192.168.1.0/26'
param appgwname string = 'appgw-aca-demo'

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
    addressPrefix: vnetPrefix
    location: location
    name: vnetname
    acaSubnetName: acaSubnetName
    acaSubnetAddressPrefix: acaSubnetPrefix
    appgwSubnetName: appgwSubnetName
    appgwSubnetPrefix: appgwSubnetPrefix

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

module appgw 'modules/appgw.bicep' = {
  scope: resourceGroup
  name: appgwname
  params: {
    location: location
    name: appgwname
  }
}
