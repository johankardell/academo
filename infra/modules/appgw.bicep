param name string
param location string

resource appgw 'Microsoft.Network/applicationGateways@2023-05-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_v2'
    tier: 'Standard_v2'
    capacity: 1
  }
  properties:{
    webApplicationFirewallConfiguration: {
      enabled: false
    }
  }
}
