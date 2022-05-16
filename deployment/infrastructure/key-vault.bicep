param location string
param applicationName string

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: '${applicationName}-keyvault'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: tenant().tenantId
    accessPolicies: []
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

output keyVaultName string = keyVault.name
