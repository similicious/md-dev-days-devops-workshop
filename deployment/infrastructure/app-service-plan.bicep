param applicationName string
param location string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${applicationName}-appServicePlan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

output id string = appServicePlan.id
