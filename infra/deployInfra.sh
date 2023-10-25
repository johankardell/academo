# az stack sub create --deny-settings-mode none --delete-all --location swedencentral --template-file infra.bicep -n academo --yes

# az stack sub create --deny-settings-mode none --delete-all --location swedencentral --parameters infra.bicepparam -n academo --yes

RG="rg-aca-demo"
az group create -n $RG -l swedencentral -o table

az deployment group create --name academoInfra --resource-group $RG --parameters infra.bicepparam