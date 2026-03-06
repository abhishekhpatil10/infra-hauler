#!/bin/bash

REPO_DIR="$1"

echo -e "\n🔥 --- DESTROY RANCHER LAB --- 🔥"
echo "Which deployment would you like to destroy?"
echo "1) DigitalOcean (Upstream RKE2)"
echo "2) AWS (Upstream RKE2)"
echo "3) Cancel"

read -r -p "Select an option [1-3]: " CHOICE

case $CHOICE in
    1)
        TARGET_DIR="$REPO_DIR/recipes/upstream/digitalocean/rke2"
        ;;
    2)
        TARGET_DIR="$REPO_DIR/recipes/upstream/aws/rke2"
        ;;
    *)
        echo "Cleanup cancelled."
        exit 0
        ;;
esac

if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Target directory $TARGET_DIR not found. Did you clone the repo?"
    exit 1
fi

if [ ! -f "$TARGET_DIR/terraform.tfstate" ]; then
    echo "⚠️  No terraform.tfstate found in $TARGET_DIR."
    echo "Nothing to destroy or already cleaned up."
    exit 0
fi

echo -e "\n🧨 WARNING: This will permanently delete all resources in $TARGET_DIR!"
read -r -p "Are you absolutely sure? (type 'yes' to confirm): " CONFIRM

if [ "$CONFIRM" == "yes" ]; then
    cd "$TARGET_DIR" || exit
    terraform destroy -auto-approve
    echo -e "\n✅ Infrastructure destroyed successfully."
else
    echo "Cleanup aborted."
fi