#!/usr/bin/env bash

azure_devtest_lab_url=https://portal.azure.com/#@epitechfr.onmicrosoft.com/resource/subscriptions/1eb5e572-df10-47a3-977e-b0ec272641e4/resourceGroups/t-clo-902-nts-0/providers/Microsoft.DevTestLab/labs/t-clo-902-nts-0/all_resources
time_before_configure=140
control_plane_username="$TF_VAR_VM_USERNAME"
inventory_config_path=./inventory/my-cluster/group_vars/all.yml
argocd_application_path=./kube/argocd/argocd-app-applicationset.yamlarray ina
hosts_path=./inventory/my-cluster/hosts.ini

echo "Récupération des variables d'environnement depuis le fichier .env..."
export "$(grep -v '^#' .env | xargs)"

echo "Création de l'infrastructure..."
terraform apply -replace main.tfplan -auto-approve

echo "Récupération des outputs de terraform"
control_plane_remote=$TF_VAR_VM_USERNAME@$(terraform output --raw ip_cp)
worker_1_remote=$TF_VAR_VM_USERNAME@$(terraform output --raw ip_worker_1)
worker_2_remote=$TF_VAR_VM_USERNAME@$(terraform output --raw ip_worker_2)

echo "Configuration du fichier hosts.ini pour Ansible..."

sed -i "s/%control_plane_remote%/$control_plane_remote/g" $hosts_path
sed -i "s/%worker_1_remote%/$worker_1_remote/g" $hosts_path
sed -i "s/%worker_2_remote%/$worker_2_remote/g" $hosts_path

echo "Fichier hosts.ini:"
cat $hosts_path

echo "Veuillez démarrer les VMs: $azure_devtest_lab_url"
sleep $time_before_configure

echo "Récupération de l'IP du control plane..."
control_plane_ip=$(ssh $control_plane_username@$control_plane_domain hostname -I | tr -d " \t\n\r")
echo "Control plane IP: $control_plane_ip"

sed -i "s/%control_plane_ip%/$control_plane_ip/g" $inventory_config_path

echo "Configuration de l'application ArgoCD..."
sed -i "s/%MYSQL_HOST%/$MYSQL_HOST/g" $argocd_application_path
sed -i "s/%MYSQL_USERNAME%/$MYSQL_USERNAME/g" $argocd_application_path
sed -i "s/%MYSQL_PASSWORD%/$MYSQL_PASSWORD/g" $argocd_application_path
sed -i "s/%MYSQL_DB%/$MYSQL_DB/g" $argocd_application_path
sed -i "s/%APP_KEY%/$(printf '%s\n' "$APP_KEY" | sed -e 's/[\/&]/\\&/g')/g" $argocd_application_path

echo "Configuration des VMs..."
ansible-playbook ./site.yml -i ./inventory/my-cluster/hosts.ini -v