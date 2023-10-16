param name string
param location string

resource loganalytics_workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output customerId string = loganalytics_workspace.properties.customerId
output sharedKey string = loganalytics_workspace.listKeys().primarySharedKey
