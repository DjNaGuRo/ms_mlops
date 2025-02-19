#!/bin/sh
pip install azure-ai-ml

az extension add -n ml -y

# Create a ressource group and set it as default
az group create --name rg-mlops --location "francecentral"
az configure --defaults group=rg-mlops

# Create an Azure Machine Learning workspace and set it as default
az ml workspace create --name w-mlops
az configure --defaults workspace=w-mlops

# Create another Azure Machine Learning workspace for production 
az ml workspace create --name w-mlops-prod

# Create a compute instance for ml development
az ml compute create --name compute-instance-mlops --size STANDARD_DS11_V2 --type ComputeInstance

# Create a compute cluster for production
az ml compute create --name aml-cluster --size STANDARD_DS11_V2 --max-instances 3 --type AmlCompute -w w-mlops-prod

# https://learn.microsoft.com/en-us/cli/azure/ml/data?view=azure-cli-latest
# Create a data asset using a YAML file
# using the below line if the current script is executed from the src folder otherwise (if from the root of projeect) comment the line and uncomment the next
az ml data create -f ../experimentation/data_asset.yml # -g rg-mlops -w w-mlops
#az ml data create -f experimentation/data_asset.yml # -g rg-mlops -w w-mlops

# Create a data asset using YAML file for production environment
az ml data create -f ../production/data_asset_for_prod.yml -w w-mlops-prod

# Create a data asset without a YAML file
#az ml data create -n diabetes-dev-folder -t uri_folder -p ../experimentation/data \
#    -d "Dataset created from local folder." # -g rg-mlops -w w-mlops