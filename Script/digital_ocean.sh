#!/bin/bash

# Get the library path from the main script argument
REPO_DIR="$1"
TARGET_DIR="$REPO_DIR/recipes/upstream/digitalocean/rke2"

# --- Functions for UI (Native CLI) ---
get_secret() {
    local prompt="$1"
    local secret
    read -rs -p "🔑 $prompt: " secret
    echo "$secret"
    echo "" >&2 
}

get_input() {
    local prompt="$1"
    local default="$2"
    local input
    read -r -p "📝 $prompt [$default]: " input
    echo "${input:-$default}"
}

echo -e "\n--- 🏗️  DigitalOcean Rancher Prep ---\n"

# --- 1. Collect ALL User Inputs ---
DO_TOKEN=$(get_secret "Enter your DigitalOcean API token")
[ -z "$DO_TOKEN" ] && { echo "Error: Token cannot be empty"; exit 1; }

PREFIX=$(get_input "Prefix for all resources" "infra-hauler-lab")
SSH_PATH=$(get_input "Path to private SSH key" "$HOME/.ssh/id_rsa")
RKE2_VER=$(get_input "RKE2 version (v1.xx.xx+rke2r1)" "v1.32.4+rke2r1")
RANCHER_PASS=$(get_secret "Admin password for Rancher")
RANCHER_VER=$(get_input "Rancher version" "2.12.2")

# --- 2. Create the terraform.tfvars in the target recipe folder ---
echo -e "\n📄 Generating terraform.tfvars in $TARGET_DIR..."

cat <<EOF > "$TARGET_DIR/terraform.tfvars"
do_token            = "$DO_TOKEN"
droplet_count       = 1
prefix              = "$PREFIX"
create_ssh_key_pair = "false"
ssh_key_pair_name   = "infra-hauler-key"
ssh_key_pair_path   = "$SSH_PATH"
ssh_username        = "root"
rke2_version        = "$RKE2_VER"
rancher_hostname    = "rancher"
rancher_password    = "$RANCHER_PASS"
rancher_version     = "$RANCHER_VER"
EOF

# --- 3. Execution Logic ---
echo -e "\n✅ Setup Complete!"
echo -e "📍 Recipe Location: $TARGET_DIR"
echo -n "🚀 Would you like to run 'terraform apply' now? (y/n): "
read -r CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    cd "$TARGET_DIR" || exit
    echo "🛠️ Initializing Terraform..."
    terraform init
    terraform apply -auto-approve
else
    echo -e "\n💡 To apply manually later, run:"
    echo -e "cd $TARGET_DIR && terraform init && terraform apply"
fi