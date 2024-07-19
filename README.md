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
$ ansible-playbook ./site.yml -i ./inventory/my-cluster/hosts.ini -v

# Reset des installations/configuration ansible sur les machines virtuelles
$ ansible-playbook ./reset.yml -i ./inventory/my-cluster/hosts.ini -v
```

### 3. Github Actions

#### Introduction

Github Actions est utilisé pour automatiser le déploiement de l'infrastructure lors d'un changement dans le repository.

#### Utilisation

La CI est automatiquement déclenchée lors d'un push sur la branche `main`.


## Cluster

- **LoadBalancer**: MetalLB
- **Ingress Controller**: Nginx
- **Monitoring**: Prometheus/Grafana
- **Logging**: Loki
- **GitOps**: ArgoCD
- **SSL**: Cert-Manager
- **CNI**: Flannel
- **Dashboard**: Kubernetes Dashboard

## Structure

### Credentials

Ce dossier est utilisé pour récupérer les credentials créer par les différents services créer par ansible.
Ces fichiers sont créer lors du lancement du playbook ./site.yml et créer à minima ces fichiers:

- argocd_password.txt
- grafana_password.txt
- k8s_dashboard_token.txt

### Ansbile

Architecture des dossiers/fichiers ansible

```
|- collections           
|-- ./requirements.yml   --- Fichier de configuration des collections ansible
|- inventory             
|-- my-cluster           
|--- ./hosts.init        --- Fichier de configuration des machines virtuelles
|--- group_vars          
|---- ./all.yml          --- Variables utilisées lors de la configuration des machines 
|- roles
|-- *
|--- tasks
|---- ./main.yml           --- Tâches à effectuer lors de l'application du playbook
|- ./ansible.cfg         --- Configuration ansible
```

Chaque roles est executé dans le playbook **site.yaml**.

Explications des différents roles:

**ArgoCD** -> Installation et configuration d'ArgoCD et installation d'une application de base (sample-app)

**Cert-manager** -> Installation et configuration de cert manager et création de deux issuers (staging & production)

**K3S/K3S_agent/K3S_server** -> Installation de la distribution k3s pour intégrer un cluster kube sur des bare metal vps (Azure DevTestLab dans notre cas) 

**K8S-dashboard** -> Installation et configuration du dashboard kubernetes et extraction du mot de passe (cf: Credentials)

**Kube Prometheus** -> Installation et configuration de prometheus et grafana pour la supervision du cluster et des applications

**Loki** -> Installation et configuration de loki pour la centralisation des logs

**Nginx** -> Installation et configuration d'un ingress controller pour le cluster kubernetes (désactivation de traefik dans notre cas)

**SSH** -> Configuration des clés ssh pour les machines virtuelles (copie des fichiers '.pub' dans le dossier 'ssh')

**Vault** -> Installation et configuration de vault pour la gestion des secrets

### Kubernetes

Architecture des dossiers/fichiers kube

```
|- kube           
|-- argocd
|--- ./argocd-app-applicationset.yaml               --- Fichier de configuration de l'application argocd
|--- ./argocd-nginx-ingress.yaml                    --- Fichier de configuration de l'ingress pour argocd
|--- ./argocd-valuyes.yaml                          --- Fichier de configuration helm pour override les valeurs par défaut
|--- apps
|---- ./sample-app.yaml                             --- Fichier de configuration ArgoCD pour la création de l'application sample-app
|-- dashboard
|--- ./dashboard-cluster-role_binding.yaml          --- Fichier de configuration du dashboard kubernetes
|--- ./dashboard-nginx-ingress.yaml                 --- Fichier de configuration de l'ingress pour le dashboard kubernetes
|--- ./dashboard-service_account.yaml               --- Fichier de configuration du service account pour le dashboard kubernetes
|-- grafana
|--- ./grafana-values.yaml                          --- Fichier de configuration helm pour grafana
|-- issuers
|--- ./staging-issuer.yaml                          --- Fichier de configuration de l'issuer letsencrypt de staging
|--- ./prod-issuer.yaml                             --- Fichier de configuration de l'issuer letsencrypt de production
|-- nginx
|--- ./nginx-deploy.yaml                            --- Fichier de configuration du déploiement de l'ingress controller nginx
|--- ./nginx-ingress-controller-load-balancer.yaml                --- Fichier de configuration de l'ingress controller nginx
```
### Helm

Une application helm est créer depuis l'image docker de notre repo privé "ghcr.io/msc1-nan24/t-clo-app"

Architecture des dossiers/fichiers helm

```
|- chart-t-clo           
|-- ./Chart.yaml                        --- Fichier de configuration du chart
|-- ./values.yaml                       --- Fichier de configuration des valeurs par défaut
|-- templates
|--- ./deployment.yaml                  --- Fichier de configuration du déploiement
|--- ./horizontal-pod-autoscaler.yaml   --- Fichier de configuration de l'auto-scaling
|--- ./ingress.yaml                     --- Fichier de configuration de l'ingress
|--- ./service.yaml                     --- Fichier de configuration du service
```

### Terraform

Architecture des dossiers/fichiers Terraform

```
|- ./main.tf
|- ./outputs.tf
|- ./variables.tf
```

## CI CD

### Repertoire

Nous utilisons 2 répertoires github pour notre projet.

#### Application
Un répertoire contenant le code source de notre application. La création d'une release dans ce repertoire déclenche la création d'une image stockée dans la registry de github.

#### Infrastructure
Un répertoire contenant le code terraform pour la création de notre infrastructure. Ce répertoire est lié à notre instance d'argoCD pour manager notre application. Une push ou un pull request sur la branche main déclenche la mise à jour de notre infrastructure.

_Actuellement un souci d'autorisation Azure empêche la mise à jour de l'infrastructure._
