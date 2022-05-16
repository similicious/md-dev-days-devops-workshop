param applicationName string
param location string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${applicationName}-insights'
  kind: 'web'
  location: location
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    Flow_Type: 'Bluefield'
  }
}

output appInsightsKey string = reference(applicationInsights.id, '2020-02-02').InstrumentationKey
