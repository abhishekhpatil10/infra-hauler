#!/bin/bash

TF_VARS="terraform.tfvars"

# --- Functions for UI (Native CLI) ---
# These replace the whiptail versions with standard terminal prompts
get_secret() {
    local prompt="$1"
    local secret
    # -s flag hides the characters as you type (perfect for tokens/passwords)
    read -rs -p "🔑 $prompt: " secret
    echo "$secret"
    echo "" >&2 # Add a newline to terminal after hidden input
}

get_input() {
    local prompt="$1"
    local default="$2"
    local input
    read -r -p "📝 $prompt [$default]: " input
    # If user just hits Enter, use the default value
    echo "${input:-$default}"
}

# --- 1. Collect User Inputs ---
echo -e "\n--- DigitalOcean Configuration ---\n"

DO_TOKEN=$(get_secret "Enter your DigitalOcean API token")
[ -z "$DO_TOKEN" ] && { echo "Error: Token cannot be empty"; exit 1; }

PREFIX=$(get_input "Prefix for all resources" "abhishekh-rancher-support")
SSH_PATH=$(get_input "Provide ssh private key pair path" "/home/abhishekh/.ssh/id_rsa")
RKE2_VER=$(get_input "Provide the rke2 version (v1.xx.xx+rke2r1)" "v1.32.4+rke2r1")
RANCHER_PASS=$(get_secret "Provide admin password for Rancher")
RANCHER_VER=$(get_input "Enter the Rancher version" "2.12.2")

# --- 2. Create the File with Default Template ---
cat <<EOF > "$TF_VARS"
# DigitalOcean authentication token
do_token = "$DO_TOKEN"
# Number of droplets to provision
droplet_count = 1
# A string that will prefix the name of all resources
prefix = "$PREFIX"
# Switch on/off new ssh keypair generation
create_ssh_key_pair = "false"
# If 'create_ssh_key_pair' is set to false, give the name of an ssh key on DigitalOcean
ssh_key_pair_name = "abhishekh-do-key"
# Path to private key
ssh_key_pair_path = "$SSH_PATH"
# ssh username used to access DigitalOcean droplets
ssh_username = "root"
## -- RKE2 version
rke2_version = "$RKE2_VER"
## -- Hostname to set when installing Rancher
rancher_hostname = "rancher"
## -- Admin password to set for Rancher
rancher_password = "$RANCHER_PASS"
## -- Rancher version to use when installing
rancher_version = "$RANCHER_VER"
EOF

# --- 3. Final Execution ---
echo -e "\n✅ $TF_VARS has been created and updated."
echo -n "🚀 Would you like to run 'terraform apply' now? (y/n): "
read -r CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    terraform init && terraform apply -auto-approve
else
    echo "Configuration complete. Terraform apply skipped."
fi