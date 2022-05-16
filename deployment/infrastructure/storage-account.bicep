param applicationName string
param location string
param keyVaultName string

var storageAccountName = '${applicationName}storage'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource keyVaultSettings 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: keyVaultName
  resource storageConnectionString 'secrets' = {
    name: '${storageAccountName}-ConnectionString'
    properties: {
      value: 'DefaultsEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', storageAccountName), '2021-09-01').keys[0].value};EndpointSuffix=core.windows.net'
    }
  }
}

output storageAccountSecretUri string = keyVaultSettings::storageConnectionString.properties.secretUri
