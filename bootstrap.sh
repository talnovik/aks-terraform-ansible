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

# Initialize Terraform
echo "Applying Terraform configuration..."
terraform -chdir=./terraform apply main.tfplan
terraform -chdir=./terraform output kube_config | sed '/^<<EOT$/d; /^EOT$/d' > ./shared/azurek8s
export KUBECONFIG=./shared/azurek8s
export K8S_AUTH_KUBECONFIG=./../shared/azurek8s


# Wait for all nodes to have external IPs
echo "Waiting for nodes to have external IPs..."
while true; do
  NODE_IPS=$(kubectl get nodes -o wide --no-headers | awk '{print $7}' | grep -v '<none>')
  NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
  if [ "$(echo "$NODE_IPS" | wc -l)" -eq "$NODE_COUNT" ]; then
    break
  fi
  sleep 5
done

# Generate inventory.ini
echo "Generating inventory.ini..."
INVENTORY_FILE="./ansible/inventory.ini"
PRIVATE_KEY_FILE="./shared/ssh_private_key.pem"
export ANSIBLE_HOST_KEY_CHECKING=False

echo "[nodes]" > "$INVENTORY_FILE"
kubectl get nodes -o wide --no-headers | awk -v key="$PRIVATE_KEY_FILE" '{print $7, "ansible_ssh_private_key_file=" key, "ansible_user=azureadmin"}' >> "$INVENTORY_FILE"

echo "Inventory file created at $INVENTORY_FILE"

echo "Installing Ansible requirements..."
ansible-galaxy collection install -r ansible/requirements.yml

echo "Running Ansible playbook..."
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml