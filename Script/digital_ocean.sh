#!/bin/bash

# Get the library path from the main script argument
REPO_DIR="$1"
TARGET_DIR="$REPO_DIR/recipes/upstream/digitalocean/rke2"

# Functions for input
get_secret() { read -rs -p "🔑 $1: " val; echo "$val"; echo "" >&2; }
get_input() { read -r -p "📝 $1 [$2]: " val; echo "${val:-$2}"; }

# Collect Data
DO_TOKEN=$(get_secret "Enter DigitalOcean Token")
PREFIX=$(get_input "Resource Prefix" "hauler-lab")
SSH_PATH=$(get_input "SSH Private Key Path" "$HOME/.ssh/id_rsa")

# Write the file directly into the cloned repo recipe
echo "📄 Generating terraform.tfvars in $TARGET_DIR..."
cat <<EOF > "$TARGET_DIR/terraform.tfvars"
do_token            = "$DO_TOKEN"
prefix              = "$PREFIX"
ssh_key_pair_path   = "$SSH_PATH"
# ... (add other variables here)
EOF

# Execution
echo -n "🚀 Run 'terraform apply' now? (y/n): "
read -r CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    cd "$TARGET_DIR" && terraform init && terraform apply -auto-approve
fi