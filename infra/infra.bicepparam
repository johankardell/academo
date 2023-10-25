// Trying to implement this: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files?tabs=Bicep
// Can't get it to work. This file is not used right now.

using 'infra.bicep'

param location = 'swedencentral'
param acrname = 'acrjkacademo'
param lawname = 'lajkacademo'
param envname = 'acaenvdemo'
param ainame = 'ai-academo'
param vnetname = 'acavnet'
param vnetPrefix = '192.168.0.0/23'
param acaSubnetName = 'acasubnet'
param acaSubnetPrefix = '192.168.0.0/26'
param appgwSubnetName = 'appgwsubnet'
param appgwSubnetPrefix = '192.168.1.0/26'
