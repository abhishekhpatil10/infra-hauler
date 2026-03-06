#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define colors for a professional look
BLUE='\033[0;34m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}${BOLD}==================================================${NC}"
echo -e "${GREEN}${BOLD}      🏗️  INFRA-HAULER: Rancher Lab Automator      ${NC}"
echo -e "${BLUE}${BOLD}==================================================${NC}"
echo -e "Choose a deployment option:\n"

options=(
    "Rancher Local cluster on AWS"
    "Rancher Local cluster on Digital-Ocean"
    "Downstream RKE2 cluster Digital-Ocean"
    "Downstream RKE2 cluster on AWS"
    "Exit"
)

# PS3 is the prompt used by the 'select' command
PS3=$'\n'"Select a number (1-${#options[@]}): "

select opt in "${options[@]}"
do
    case $opt in
        "Rancher Local cluster on AWS")
            echo -e "\n🚀 Starting AWS Deployment..."
            bash "$SCRIPT_DIR/aws.sh"
            break
            ;;
        "Rancher Local cluster on Digital-Ocean")
            echo -e "\n🚀 Starting DigitalOcean Deployment..."
            bash "$SCRIPT_DIR/digital_ocean.sh"
            break
            ;;
        "Downstream RKE2 cluster Digital-Ocean")
            echo -e "\n🚀 Starting RKE2 DigitalOcean Deployment..."
            bash "$SCRIPT_DIR/RKE2.sh"
            break
            ;;
        "Downstream RKE2 cluster on AWS")
            echo -e "\n🚀 Starting RKE2 AWS Deployment..."
            echo "Coming soon!"
            break
            ;;
        "Exit")
            echo -e "\n👋 Exiting. Happy hauling!"
            exit 0
            ;;
        *) 
            echo -e "\n❌ Invalid option $REPLY. Please pick a number from the list."
            ;;
    esac
done