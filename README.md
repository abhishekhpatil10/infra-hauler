# 🏗️ infra-hauler

**Any cloud, Rancher labs in minutes.**

`infra-hauler` is a lightweight, high-performance CLI tool designed to automate the deployment of Rancher and RKE2 clusters across multiple cloud providers. By wrapping complex automation scripts into a single, portable binary, it eliminates the need for manual script management and configuration overhead.

---

## 📖 Overview

This project is designed to help users quickly set up Rancher and RKE2 clusters across various cloud providers (AWS, DigitalOcean, etc.). The tool uses an interactive CLI menu to guide users through the process of:

* Creating Rancher management clusters.
* Provisioning downstream RKE2 clusters.
* Automating the installation of necessary dependencies (like `whiptail`, `kubectl`, etc.).

By using a Go-based wrapper, the entire script library is packed into a single executable, ensuring that the tool works exactly the same way on any machine without requiring you to manually download multiple `.sh` files.

---

## 🚀 Quick Start

Get the latest version of `infra-hauler` for your operating system. No Go or Bash knowledge is required—just download and run.

### 📥 Download Latest Binary

| Operating System | Architecture | Download Link |
| :--- | :--- | :--- |
| **Linux** | 64-bit (amd64) | [**Download**](./releases/infra-hauler-linux) |
| **macOS** | Apple Silicon (M1/M2/M3) | [**Download**](./releases/infra-hauler-macos-m1) |
| **macOS** | Intel | [**Download**](./releases/infra-hauler-macos-intel) |

### 🛠️ Installation & Usage

1. **Make the binary executable:**
   ```bash
   chmod +x infra-hauler-linux
2. **Run the tool:**
   ```bash
   ./infra-hauler-linux
3. **(Optional) Move to your PATH:**
   ```bash
   sudo mv infra-hauler-linux /usr/local/bin/infra-hauler
   infra-hauler


