#!/bin/bash

# Setup Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/rancher/tf-rancher-up"
REPO_NAME="tf-rancher-up"

# 1. Pre-flight Check: Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: 'git' is not installed. Please install git to continue."
    exit 1
fi

# 2. Setup the Rancher Template Library
echo -e "\n📦 Initializing Rancher Template Library..."
if [ -d "$REPO_NAME" ]; then
    echo "🔄 Library exists. Updating to latest version..."
    (cd "$REPO_NAME" && git pull) &> /dev/null
else
    echo "📥 Cloning Rancher templates..."
    git clone "$REPO_URL" &> /dev/null
fi

# 3. Main Menu
clear
echo "=================================================="
echo "      🏗️  INFRA-HAULER: Rancher Lab Automator     "
echo "=================================================="
echo -e "Choose an action:\n"

options=(
    "Rancher Local cluster on AWS"
    "Rancher Local cluster on Digital-Ocean"
    "Downstream RKE2 cluster Digital-Ocean"
    "🔥 DESTROY an existing Lab"
    "Exit"
)

select opt in "${options[@]}"
do
    case $opt in
        "Rancher Local cluster on AWS")
            bash "$SCRIPT_DIR/aws.sh" "$REPO_NAME"
            break ;;
        "Rancher Local cluster on Digital-Ocean")
            bash "$SCRIPT_DIR/digital_ocean.sh" "$REPO_NAME"
            break ;;
        "🔥 DESTROY an existing Lab")
            # Call the destroy logic
            bash "$SCRIPT_DIR/destroy.sh" "$REPO_NAME"
            break ;;
        "Exit")
            exit 0 ;;
        *) 
            echo "Invalid option $REPLY" ;;
    esac
done