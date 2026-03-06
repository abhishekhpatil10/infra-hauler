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

# --- 1. Collect User Inputs ---
DO_TOKEN=$(get_secret "Enter your DigitalOcean API token")
[ -z "$DO_TOKEN" ] && { echo "❌ Error: Token cannot be empty"; exit 1; }

PREFIX=$(get_input "Prefix for all resources" "infra-hauler-lab")
REGION=$(get_input "DigitalOcean Region" "blr1")
SSH_KEY_NAME=$(get_input "SSH Key Name (as shown on DO dashboard)" "infra-hauler-key")
SSH_PATH=$(get_input "Path to local private SSH key" "$HOME/.ssh/id_rsa")
RKE2_VER=$(get_input "RKE2 version (v1.xx.xx+rke2r1)" "v1.32.4+rke2r1")
RANCHER_PASS=$(get_secret "Admin password for Rancher")
RANCHER_VER=$(get_input "Rancher version" "2.12.2")

# --- 2. Create the terraform.tfvars in the target recipe folder ---
echo -e "\n📄 Generating terraform.tfvars in $TARGET_DIR..."

cat <<EOF > "$TARGET_DIR/terraform.tfvars"
do_token            = "$DO_TOKEN"
region              = "$REGION"
droplet_count       = 1
prefix              = "$PREFIX"
create_ssh_key_pair = "false"
ssh_key_pair_name   = "$SSH_KEY_NAME"
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
    
    echo -e "\n🛠️  Initializing Terraform... (This may take a minute)"
    terraform init -input=false > /tmp/tf_init.log 2>&1
    
    if [ $? -ne 0 ]; then
        echo "❌ Terraform Init Failed! Check /tmp/tf_init.log"
        exit 1
    fi

    echo -e "🏗️  Deploying Rancher Lab on DigitalOcean..."
    echo -e "⏳ This usually takes 5-8 minutes. Please wait.\n"

    # Start Terraform in the background and hide output
    terraform apply -auto-approve > terraform_deploy.log 2>&1 &
    TF_PID=$!

    # Simple Loading Animation
    spinner=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
    while kill -0 $TF_PID 2>/dev/null; do
        for i in "${spinner[@]}"; do
            echo -ne "\r  $i Working... (Tail logs in another terminal: tail -f $TARGET_DIR/terraform_deploy.log)"
            sleep 0.1
        done
    done

    # Check if it finished successfully
    wait $TF_PID
    if [ $? -eq 0 ]; then
        echo -e "\r✨ SUCCESS! Your Rancher Lab is ready."
        echo "--------------------------------------------------"
        # Extract the Rancher URL from the state/output if available
        terraform output
        echo "--------------------------------------------------"
    else
        echo -e "\r❌ DEPLOYMENT FAILED!"
        echo "Check the detailed log here: $TARGET_DIR/terraform_deploy.log"
        exit 1
    fi

else
    echo -e "\n💡 To apply manually later, run:"
    echo -e "cd $TARGET_DIR && terraform init && terraform apply"
fi