# T-CLOUD-INFRA

Ce repo contient le code Terraform pour créer l'infrastructure du projet Epitech T-CLOUD-800

## Infrastructure

### 1. Terraform

#### Introduction

Terraform est utilisé pour créé automatiquement les machines virtuelles sur le cloud provider Azure.

- 2 worker nodes
- 1 control plane

Le provider utilisé est Azure pour créer des machines sur un DevTestLab.

Lorsque terraform est lancé, les machines virtuelles sont créées et un fichier `inventory.ini` est généré pour Ansible par la CI.

#### Utilisation

```bash
# Initialisation des providers 
$ terraform init

# Planification de l'infrastructure
$ terraform plan -out main.tfplan

# Application de l'infrastructure
$ terraform apply -replace main.tfplan
```

### 2. Ansible

#### Introduction

Ansible est utilisé pour automatiser la configuration des machines virtuelles. 

#### Utilisation

```bash
# Installation des rôles/jobs/tasks Ansible
$ ansible-playbook -i hosts.ini playbook.yml
```

### 3. Github Actions

#### Introduction

Github Actions est utilisé pour automatiser le déploiement de l'infrastructure lors d'un changement dans le repository.

#### Utilisation

La CI est automatiquement déclenchée lors d'un push sur la branche `main`.

###


## Cluster

LoadBalancer: MetalLB
Ingress Controller: Nginx
Monitoring: Prometheus/Grafana
Logging: Loki
GitOps: ArgoCD
SSL: Cert-Manager
CNI: Flannel
Dashboard: Kubernetes Dashboard

```
