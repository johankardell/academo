az stack sub create --deny-settings-mode none --delete-all --location swedencentral --template-file infra.bicep -n academo --yes

# az stack sub create --deny-settings-mode none --delete-all --location swedencentral --parameters infra.bicepparams -n academo --yes # Doesn't seem to be supported yet

# az deployment group create --name academoInfra --parameters infra.bicepparams --location swedencentral -g test