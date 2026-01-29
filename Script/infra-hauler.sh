#!/bin/bash

# Function to handle whiptail installation with a progress bar
install_whiptail() {
    {
        echo "XXX"; echo "10"; echo "Detecting OS..."; echo "XXX"
        OS_TYPE=$(uname)
        sleep 1

        if [ "$OS_TYPE" = "Darwin" ]; then
            echo "XXX"; echo "40"; echo "Updating Homebrew..."; echo "XXX"
            # Redirecting all output to /dev/null to keep it clean
            brew update > /dev/null 2>&1
            echo "XXX"; echo "70"; echo "Installing whiptail (newt)..."; echo "XXX"
            brew install newt > /dev/null 2>&1
        elif [ "$OS_TYPE" = "Linux" ]; then
            echo "XXX"; echo "40"; echo "Updating package lists..."; echo "XXX"
            if [ -f /etc/debian_version ]; then
                sudo apt update -y > /dev/null 2>&1
                echo "XXX"; echo "80"; echo "Installing whiptail..."; echo "XXX"
                sudo apt install -y whiptail > /dev/null 2>&1
            elif [ -f /etc/os-release ]; then
                source /etc/os-release
                if [[ "$ID" == "opensuse"* || "$ID" == "sles" ]]; then
                    sudo zypper install -y newt > /dev/null 2>&1
                elif [[ "$ID" == "fedora" || "$ID" == "rhel" ]]; then
                    sudo dnf install -y newt > /dev/null 2>&1
                fi
            fi
        fi
        echo "XXX"; echo "100"; echo "Preparation complete!"; echo "XXX"
        sleep 1
    } | whiptail --title "System Setup" --gauge "Ensuring whiptail is installed..." 6 60 0
}

# Run the installation check first
install_whiptail

# --- Main Script ---
# You can now modify these options freely.
OPTION=$(whiptail --title "[INFRA-HAULER] Any cloud,Rancher labs in minutes" --menu "Choose your option" 15 60 4 \
"1" "Rancher Local cluster on AWS" \
"2" "Rancher Local cluster on Digitial-Ocean" \
"3" "Downstream RKE2 cluster Digitial-Ocean" \
"4" "Downstream RKE2 cluster on AWS" \
"5" "Exit" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    case "$OPTION" in
        1)
            sh /usr/bin/MTD/aws.sh
            ;;
        2)
            sh /usr/bin/MTD/DO.sh
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
