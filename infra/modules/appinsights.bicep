param name string
param location string = resourceGroup().location
param workspace_name string

resource la 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspace_name
}


resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: la.id
  }
}

output connectionstring string = appinsights.properties.ConnectionString
output instrumentationkey string = appinsights.properties.InstrumentationKey
