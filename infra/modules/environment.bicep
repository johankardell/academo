param name string
param location string

param laCustomerId string
param laSharedKey string

param subnetId string

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
    // daprAIInstrumentationKey: appinsights.properties.InstrumentationKey
    // daprAIConnectionString: appinsights.properties.ConnectionString
  }
}

output id string = aca_env.id
