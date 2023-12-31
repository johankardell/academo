param name string
param location string = resourceGroup().location
param workspace_id string

resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace_id
  }
}

output connectionstring string = appinsights.properties.ConnectionString
output instrumentationkey string = appinsights.properties.InstrumentationKey
