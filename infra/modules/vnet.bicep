param name string
param location string
param addressPrefix string
param acaSubnetName string
param acaSubnetAddressPrefix string
param appgwSubnetName string
param appgwSubnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: acaSubnetName
        properties: {
          addressPrefix: acaSubnetAddressPrefix
          delegations: [
            {
              name: 'containerapps'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
      {
        name: appgwSubnetName
        properties: {
          addressPrefix: appgwSubnetPrefix
        }
      }
    ]
  }
}

output subnetId string = vnet.properties.subnets[0].id
