#!/bin/bash

if [ -f .env ]; then
  echo "Loading .env..."
  set -a
  source .env
  set +a
else
  echo ".env file not found. Please create one from .env.example"
  exit 1
fi

terraform -chdir=./terraform init -upgrade
terraform -chdir=./terraform plan -out main.tfplan

