# Kubernetes Infrastructure Deployment with Terraform, Ansible, and ArgoCD

This project automates the deployment of a Kubernetes cluster on Azure using Terraform, configures it with Ansible, and manages applications with ArgoCD.

## Project Structure

- **terraform**: Contains Terraform configurations for provisioning Azure resources, including a Kubernetes cluster.
- **ansible**: Contains Ansible playbooks for configuring the Kubernetes cluster and deploying Helm charts.

## Prerequisites

1. **Terraform**: Install Terraform.
2. **Ansible**: Install Ansible.
3. **Azure CLI**: Install Azure CLI and authenticate.
4. **kubectl**: Install `kubectl` for Kubernetes management.
5. **Helm**: Install Helm for managing Kubernetes charts.
6. **Dynu**: Register to [Dynu](https://www.dynu.com/) and make a Dynamic DNS Service

## Setup Instructions

### 1. Configure Environment Variables

Create a `.env` file based on `.env.example` and populate it with the required values:

```bash
cp .env.example .env
```

### 2. Run the build.sh script

It will init and plan the terraform infrastructure

```bash
source build.sh
```

### 3. Run the bootstarp.sh script

It will start the process of creating the whole infrastructure

```bash
source bootstarp.sh
```

### 4. Access Deployed Applications

- **Ingress Controller**: Access via the external IP of the ingress controller.
- **ArgoCD**: Access ArgoCD at `argocd.<your-domain>`.
- **Prometheus**: Access Prometheus at `prometheus.<your-domain>`.
- **Grafana**: Access Grafana at `grafana.<your-domain>`.
- **Kubernetes Dashboard** Access the Dashboard at `dashboard.<your-domain>`.

## Key Components

### Terraform

- **Resource Group**: Dynamically named using `random_pet`.
- **Kubernetes Cluster**: Configured with a single node pool and SSH key integration.
- **SSH Key Management**: Generates and stores SSH keys securely.

### Ansible

- **Helm Repositories**: Adds repositories for ArgoCD, Prometheus, and Kubernetes Dashboard.
- **Helm Charts**: Deploys Ingress Controller, ArgoCD, and Kubernetes Dashboard.
- **DNS Configuration**: Updates Dynu DNS with the external IP of the ingress controller.
- **Package Installation**: Installs net-tools on the nodes

### ArgoCD

- **Prometheus Stack**: Manages Prometheus and Grafana using ArgoCD.

## Outputs

After running Terraform, the following outputs are available:

- **Resource Group Name**
- **Kubernetes Cluster Name**
- **Kubeconfig**: Access credentials for the Kubernetes cluster.

## Cleanup

To destroy all resources, run the script destroy.sh:

```bash
source destroy.sh
```
