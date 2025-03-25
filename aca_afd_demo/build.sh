# https://learn.microsoft.com/en-us/azure/container-apps/how-to-integrate-with-azure-front-door

# az extension add --name containerapp --upgrade --allow-preview true

RESOURCE_GROUP="rg-aca-afd-demo"
LOCATION="swedencentral"
ENVIRONMENT_NAME="aca-afd-demo"
CONTAINERAPP_NAME="aca-afd-demo"
AFD_PROFILE="my-afd-profile"
AFD_ENDPOINT="my-afd-endpoint"
AFD_ORIGIN_GROUP="my-afd-origin-group"
AFD_ORIGIN="my-afd-origin"
AFD_ROUTE="my-afd-route"

az group create --name $RESOURCE_GROUP --location $LOCATION

az containerapp env create --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

ENVIRONMENT_ID=$(az containerapp env show --resource-group $RESOURCE_GROUP --name $ENVIRONMENT_NAME --query "id" --output tsv)

az containerapp env update --id $ENVIRONMENT_ID --public-network-access Disabled

az containerapp up --name $CONTAINERAPP_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --environment $ENVIRONMENT_NAME --image mcr.microsoft.com/k8se/quickstart:latest --target-port 80 --ingress external --query properties.configuration.ingress.fqdn

ACA_ENDPOINT=$(az containerapp show --name $CONTAINERAPP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn --output tsv)

az afd profile create --profile-name $AFD_PROFILE --resource-group $RESOURCE_GROUP --sku Premium_AzureFrontDoor

az afd endpoint create --resource-group $RESOURCE_GROUP --endpoint-name $AFD_ENDPOINT --profile-name $AFD_PROFILE --enabled-state Enabled

az afd origin-group create --resource-group $RESOURCE_GROUP --origin-group-name $AFD_ORIGIN_GROUP --profile-name $AFD_PROFILE --probe-request-type GET --probe-protocol Http --probe-interval-in-seconds 60 --probe-path / --sample-size 4 --successful-samples-required 3 --additional-latency-in-milliseconds 50/subscriptions/c1bc5dd7-ea97-469c-89fa-8f26624902fd/resourceGroups/eafd-Prod-swedencentral/providers/Microsoft.Network/privateEndpoints/afead5ea-f213-46d9-a0d0-9d062548e682/subscriptions/c1bc5dd7-ea97-469c-89fa-8f26624902fd/resourceGroups/eafd-Prod-swedencentral/providers/Microsoft.Network/privateEndpoints/afead5ea-f213-46d9-a0d0-9d062548e682

az network private-endpoint-connection list --name $ENVIRONMENT_NAME --resource-group $RESOURCE_GROUP --type Microsoft.App/managedEnvironments

# approve private endpoint connection in portal

az afd route create --resource-group $RESOURCE_GROUP --profile-name $AFD_PROFILE --endpoint-name $AFD_ENDPOINT --forwarding-protocol MatchRequest --route-name $AFD_ROUTE --https-redirect Enabled --origin-group $AFD_ORIGIN_GROUP --supported-protocols Http Https --link-to-default-domain Enabled

az afd endpoint show --resource-group $RESOURCE_GROUP --profile-name $AFD_PROFILE --endpoint-name $AFD_ENDPOINT --query hostName --output tsv
