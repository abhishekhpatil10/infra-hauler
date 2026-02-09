#!/bin/bash

TF_VARS="terraform.tfvars"

# --- Functions for UI ---
get_secret() {
    local val=$(whiptail --title "Secure Input" --passwordbox "$1" 10 60 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && exit 1
    echo "$val"
}

get_input() {
    local val=$(whiptail --title "Digital Ocean Config" --inputbox "$1" 10 60 "$2" 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && exit 1
    echo "$val"
}

# --- 1. Collect User Inputs ---
DO_TOKEN=$(get_secret "Enter your Digital Ocean API token:")
PREFIX=$(get_input "Prefix for all resources:" "abhishekh-rancher-support")
SSH_PATH=$(get_input "Provide ssh private key pair path:" "/home/abhishekh/.ssh/id_rsa")
RKE2_VER=$(get_input "Provide the rke2 version (v1.xx.xx+rke2r1):" "v1.32.4+rke2r1")
RANCHER_PASS=$(get_secret "Provide admin password set for Rancher:")
RANCHER_VER=$(get_input "Enter the Rancher version:" "2.12.2")

# --- 2. Create the File with Default Template ---
# This recreates your original file structure exactly 
cat <<'EOF' > "$TF_VARS"
# DigitalOcean authentication token
do_token = ""

# Number of droplets to provision
droplet_count = 1

# Droplet Machine Type/Size
# droplet_size = "g-4vcpu-16gb"

# A string that will prefix the name of all resources
prefix = "abhishekh-rancher-support"

# Switch on/off new ssh keypair generation
create_ssh_key_pair = "false"

# If 'create_ssh_key_pair' is set to false, give the name of an ssh key on DigitalOcean
ssh_key_pair_name = "abhishekh-custom"

# Path to private key
ssh_key_pair_path = "/home/abhishekh/.ssh/id_rsa"

# ssh username used to access DigitalOcean droplets
ssh_username = "root"

## -- RKE2 version
rke2_version = "v1.32.4+rke2r1"

## -- Hostname to set when installing Rancher
rancher_hostname = "rancher"

## -- Admin password to set for Rancher
rancher_password = "rancher123456"

## -- Rancher version to use when installing
rancher_version = "2.12.2"
EOF

# --- 3. Replace Template values with User Inputs ---
# We use 'sed' to update only the specific keys requested [cite: 1, 3]
sed -i "s|^do_token *=.*|do_token = \"$DO_TOKEN\"|" "$TF_VARS"
sed -i "s|^prefix *=.*|prefix = \"$PREFIX\"|" "$TF_VARS"
sed -i "s|^ssh_key_pair_path *=.*|ssh_key_pair_path = \"$SSH_PATH\"|" "$TF_VARS"
sed -i "s|^rke2_version *=.*|rke2_version = \"$RKE2_VER\"|" "$TF_VARS"
sed -i "s|^rancher_password *=.*|rancher_password = \"$RANCHER_PASS\"|" "$TF_VARS"
sed -i "s|^rancher_version *=.*|rancher_version = \"$RANCHER_VER\"|" "$TF_VARS"

# --- 4. Final Execution ---
if whiptail --title "Success" --yesno "File created and updated. Run terraform apply?" 10 60; then
    terraform init && terraform apply -auto-approve
else
    echo "Configuration complete. Terraform apply skipped."
fi
