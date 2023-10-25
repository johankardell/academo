param name string
param location string = resourceGroup().location

param laCustomerId string
param laSharedKey string

param subnetId string

param aiconnectionstring string
param aiinstrumentationkey string

resource aca_env 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: name
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: laCustomerId
        sharedKey: laSharedKey
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
  }
}

output id string = aca_env.id
