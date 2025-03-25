param name string
param location string = resourceGroup().location

// param laCustomerId string
// param laSharedKey string

param workspace_name string

param subnetId string

param aiconnectionstring string
param aiinstrumentationkey string

resource la 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspace_name
}

resource aca_env 'Microsoft.App/managedEnvironments@2024-10-02-preview' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: la.properties.customerId
        sharedKey: la.listKeys().primarySharedKey
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    vnetConfiguration: {
      infrastructureSubnetId: subnetId
      internal: false
    }
    daprAIInstrumentationKey: aiinstrumentationkey
    daprAIConnectionString: aiconnectionstring
    infrastructureResourceGroup: 'rg-aca-demo-infra'
    zoneRedundant: true
  }
}

output id string = aca_env.id
