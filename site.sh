#!/usr/bin/env bash

azure_devtest_lab_url=https://portal.azure.com/#@epitechfr.onmicrosoft.com/resource/subscriptions/1eb5e572-df10-47a3-977e-b0ec272641e4/resourceGroups/t-clo-902-nts-0/providers/Microsoft.DevTestLab/labs/t-clo-902-nts-0/all_resources
time_before_configure=1
control_plane_username=cloudtoto
control_plane_domain=control-plane-vm-iac.westeurope.cloudapp.azure.com
inventory_config_path=./inventory/my-cluster/group_vars/all.yml

echo "Création de l'infrastructure..."
terraform apply -replace main.tfplan -auto-approve

echo "Veuillez démarrer les VMs: $azure_devtest_lab_url"
sleep $time_before_configure

echo "Récupération de l'IP du control plane..."
control_plane_ip=$(ssh $control_plane_username@$control_plane_domain hostname -I | tr -d " \t\n\r")
echo "Control plane IP: $control_plane_ip"

sed -i "s/%control_plane_ip%/$control_plane_ip/g" $inventory_config_path

echo "Configuration des VMs..."
ansible-playbook ./site.yml -i ./inventory/my-cluster/hosts.ini -v