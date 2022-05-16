param applicationName string
param location string

module keyVault 'key-vault.bicep' = {
  name: 'keyVault-deployment'
  params: {
    applicationName: applicationName
    location: location
  }
}

module applicationInsights 'application-insights.bicep' = {
  name: 'applicationInsights-deployment'
  params: {
    applicationName: applicationName
    location: location
  }
}

module storageAccount 'storage-account.bicep' = {
  name: 'storageAccount-deployment'
  params: {
    applicationName: applicationName
    location: location
    keyVaultName: keyVault.outputs.keyVaultName
  }
  dependsOn: [
    keyVault
  ]
}

module appServicePlan 'app-service-plan.bicep' = {
  name: 'appServicePlan-deployment'
  params: {
    applicationName: applicationName
    location: location
  }
}

module functionApp 'function-app.bicep' = {
  name: 'functionApp-deployment'
  params: {
    applicationName: applicationName
    location: location
    appServicePlanId: appServicePlan.outputs.id
  }
  dependsOn: [
    applicationInsights
    storageAccount
    appServicePlan
  ]
}

module functionAppAccessPolicy 'key-vault-access-policy.bicep' = {
  name: 'keyVaultAccessPolicy-deployment'
  params: {
    keyVaultName: keyVault.outputs.keyVaultName
    principalId: functionApp.outputs.principalId
    permission: 'low'
  }
  dependsOn: [
    functionApp
    keyVault
  ]
}

module apiFunctionAppSettingsModule 'function-app-settings.bicep' = {
  name: 'functionAppSettings-deployment'
  params: {
    appInsightsKey: applicationInsights.outputs.appInsightsKey
    functionAppName: functionApp.outputs.functionAppName
    storageAccountSecretUri: storageAccount.outputs.storageAccountSecretUri
    runtime: 'dotnet'
  }
  dependsOn: [
    functionApp
    functionAppAccessPolicy
  ]
}
