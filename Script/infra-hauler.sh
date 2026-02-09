#!/bin/bash

# Function to handle installation using standard terminal output
# because we can't use whiptail to install whiptail!
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

# 1. Ensure whiptail exists first
install_dependencies

# 2. Now that we know it exists, we can use it for the UI
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
            sh /usr/bin/MTD/aws.sh
            ;;
        2)
            sh digital_ocean.sh
            ;;
        3)
            sh /usr/bin/MTD/RKE2.sh
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
