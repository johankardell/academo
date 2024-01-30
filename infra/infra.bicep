targetScope = 'resourceGroup'

param acrname string
param lawname string
param envname string
param ainame string
param vnetname string
param vnetPrefix string
param acaSubnetName string
param acaSubnetPrefix string
param appgwSubnetName string
param appgwSubnetPrefix string
param appgwname string
param location string = resourceGroup().location

module acr 'modules/acr.bicep' = {
  name: acrname
  params: {
    name: acrname
    location: location
  }
}

module law 'modules/loganalytics.bicep' = {
  name: lawname
  params: {
    name: lawname
    location: location
  }
}

module vnet 'modules/vnet.bicep' = {
  name: vnetname
  params: {
    addressPrefix: vnetPrefix
    name: vnetname
    acaSubnetName: acaSubnetName
    acaSubnetAddressPrefix: acaSubnetPrefix
    appgwSubnetName: appgwSubnetName
    appgwSubnetPrefix: appgwSubnetPrefix
    location: location
  }
}

module aca_env 'modules/aca_environment.bicep' = {
  name: envname
  params: {
    laCustomerId: law.outputs.customerId
    laSharedKey: law.outputs.sharedKey
    name: envname
    subnetId: vnet.outputs.subnetId
    aiconnectionstring: appinsights.outputs.connectionstring
    aiinstrumentationkey: appinsights.outputs.instrumentationkey
    location: location
  }
}

module appinsights 'modules/appinsights.bicep' = {
  name: ainame
  params: {
    name: ainame
    workspace_id: law.outputs.workspaceId
    location: location
  }
}

module appgw 'modules/appgw.bicep' = {
  name: appgwname
  params: {
    name: appgwname
    location: location
    subnetId: vnet.outputs.appgwSubnetId
    appurla: dummy_app_a.outputs.appurl
    appurlb: dummy_app_b.outputs.appurl
  }
}

// Add a dummy app just to setup the app gateway - will be overwritten by the real app later
module dummy_app_a 'modules/app_dummy.bicep' = {
  name: 'externalapi-a'
  params: {
    aca_env_id: aca_env.outputs.id
    containerName: 'nginx'
    image: 'nginx:latest'
    name: 'externalapi-a'
    location: location
  }
}

module dummy_app_b 'modules/app_dummy.bicep' = {
  name: 'externalapi-b'
  params: {
    aca_env_id: aca_env.outputs.id
    containerName: 'nginx'
    image: 'nginx:latest'
    name: 'externalapi-b'
    location: location
  }
}
