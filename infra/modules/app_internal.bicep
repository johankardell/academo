param location string
param name string
param aca_env_id string
param image string
param containerName string
param acrname string
param acrloginserver string
param acrsecret string
param aiconnectionstring string

resource app 'Microsoft.App/containerApps@2023-05-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    managedEnvironmentId: aca_env_id
    configuration: {
      activeRevisionsMode: 'single'
      ingress: {
        external: false
        targetPort: 80
      }
      dapr: {
        enabled: true
        appId: name
      }
      secrets: [
        {
          name: 'registry-password'
          value: acrsecret
        }
      ]
      registries: [
        {
          username: acrname
          passwordSecretRef: 'registry-password'
          server: acrloginserver
        }
      ]
    }
    template: {
      containers: [
        {
          image: image
          name: containerName
          env: [
            {
              name: 'OTEL_EXPORTER_OTLP_ENDPOINT'
              value: 'http://otel-collector-app'
            }
            {
              name: 'OTEL_EXPORTER_OTLP_PROTOCOL'
              value: 'http/protobuf'
            }
            {
              name: 'USE_CONSOLE_LOG_OUTPUT'
              value: 'true'
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: aiconnectionstring
            }
          ]
          resources:{
            cpu: json('.25')
            memory: '.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
        rules: []
      }
    }
  }
}
