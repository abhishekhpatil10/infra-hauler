#!/bin/bash

TF_VARS="terraform.tfvars"

# --- Functions for UI ---
# These now return the value. We check $? after calling them.
get_secret() {
    whiptail --title "Secure Input" --passwordbox "$1" 10 60 3>&1 1>&2 2>&3
}

get_input() {
    whiptail --title "Digital Ocean Config" --inputbox "$1" 10 60 "$2" 3>&1 1>&2 2>&3
}

# --- 1. Collect User Inputs with Manual Exit Checks ---
# We capture the output and immediately check if the user hit Cancel (exit status 1)

DO_TOKEN=$(get_secret "Enter your Digital Ocean API token:")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

PREFIX=$(get_input "Prefix for all resources:" "abhishekh-rancher-support")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

SSH_PATH=$(get_input "Provide ssh private key pair path:" "/home/abhishekh/.ssh/id_rsa")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

RKE2_VER=$(get_input "Provide the rke2 version (v1.xx.xx+rke2r1):" "v1.32.4+rke2r1")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

RANCHER_PASS=$(get_secret "Provide admin password set for Rancher:")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

RANCHER_VER=$(get_input "Enter the Rancher version:" "2.12.2")
[ $? -ne 0 ] && { echo "Cancelled"; exit 1; }

# --- 2. Create the File with Default Template ---
# This ensures the file exists with all your specific comments and structure [cite: 1, 2, 3, 4]
cat <<'EOF' > "$TF_VARS"
# DigitalOcean authentication token
do_token = ""

# Number of droplets to provision
droplet_count = 1

# A string that will prefix the name of all resources
prefix = "abhishekh-rancher-support"

# Switch on/off new ssh keypair generation
create_ssh_key_pair = "false"

# If 'create_ssh_key_pair' is set to false, give the name of an ssh key on DigitalOcean
ssh_key_pair_name = "abhishekh-do-key"

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
sed -i "s|^do_token *=.*|do_token = \"$DO_TOKEN\"|" "$TF_VARS"
sed -i "s|^prefix *=.*|prefix = \"$PREFIX\"|" "$TF_VARS"
sed -i "s|^ssh_key_pair_path *=.*|ssh_key_pair_path = \"$SSH_PATH\"|" "$TF_VARS" [cite: 3]
sed -i "s|^rke2_version *=.*|rke2_version = \"$RKE2_VER\"|" "$TF_VARS"
sed -i "s|^rancher_password *=.*|rancher_password = \"$RANCHER_PASS\"|" "$TF_VARS"
sed -i "s|^rancher_version *=.*|rancher_version = \"$RANCHER_VER\"|" "$TF_VARS"

# --- 4. Final Execution ---
if whiptail --title "Success" --yesno "File created and updated. Run terraform apply?" 10 60; then
    terraform init && terraform apply -auto-approve
else
    echo "Configuration complete. Terraform apply skipped."
fi
