targetScope = 'subscription'

param location string = 'germanywestcentral'
param resourceGroupName string

@maxLength(12)
param applicationName string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module services 'services.bicep' = {
  name: '${applicationName}-deployment'
  params: {
    applicationName: applicationName
    location: location
  }
  scope: resourceGroup
}
