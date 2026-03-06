#!/bin/bash

# --- NEW: Locate where the scripts are unpacked ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_dependencies() {
    if command -v whiptail >/dev/null 2>&1; then
        return 0
    fi

    echo "Whiptail not found. Starting installation..."
    OS_TYPE=$(uname)

    if [ "$OS_TYPE" = "Darwin" ]; then
        brew install newt
    elif [ "$OS_TYPE" = "Linux" ]; then
        if [ -f /etc/debian_version ]; then
            sudo apt update -y && sudo apt install -y whiptail
        elif [ -f /etc/os-release ]; then
            source /etc/os-release
            if [[ "$ID" == "opensuse"* || "$ID" == "sles" ]]; then
                sudo zypper install -y newt
            elif [[ "$ID" == "fedora" || "$ID" == "rhel" || "$ID" == "centos" ]]; then
                sudo dnf install -y newt
            fi
        fi
    fi
}

install_dependencies

OPTION=$(whiptail --title "[INFRA-HAULER] Any cloud, Rancher labs in minutes" --menu "Choose your option" 15 60 5 \
"1" "Rancher Local cluster on AWS" \
"2" "Rancher Local cluster on Digital-Ocean" \
"3" "Downstream RKE2 cluster Digital-Ocean" \
"4" "Downstream RKE2 cluster on AWS" \
"5" "Exit" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    case "$OPTION" in
        1)
            # Use SCRIPT_DIR to find aws.sh next to this script
            bash "$SCRIPT_DIR/aws.sh"
            ;;
        2)
            # Use SCRIPT_DIR to find digital_ocean.sh next to this script
            bash "$SCRIPT_DIR/digital_ocean.sh"
            ;;
        3)
            # Use SCRIPT_DIR to find RKE2.sh next to this script
            bash "$SCRIPT_DIR/RKE2.sh"
            ;;
        4)
            echo "DS cluster"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
    esac
else
    echo "User cancelled."
    exit 1
fi
