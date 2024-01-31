# academo
Azure Container Apps demo

Instructions for running the demo:
```
1. Run deployInfra (from the infra folder) to deploy all infrastructure components
2. Build both externalAPI and internalAPI using the scripts in each folder (apps/externalAPI and apps/internalAPI)
3. Run deployApp (from the infra folder) to deploy the container apps and build the container images
```

Instructions for removing the demo environment:
```
Run destroyDemo to destroy the environment when done
```

**Common issues:**

Is this production ready and following all best practices?
```
No, this is a demo built for a specific purpose. It is not production ready and does not follow all best practices.
```

Application gateway gets stuck waiting on container apps to be deployed:
```
Remove Application Gateway and run deployInfra again. When finished, add Application Gateway again and run deployInfra again.
```
Name collision on container registry:
```
Change the name of your container registry in infra.bicepparam file and run it again. Names have to be globally unique.
```

I'm running into issues with the keyvault after recreating the demo environment:
```
Keyvault is using soft delete, so you need to purge it or wait for it to be purged before you can recreate it. Or - use another name for the keyvault.
```