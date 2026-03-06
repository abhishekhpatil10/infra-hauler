# 🏗️ infra-hauler

**Any cloud, Rancher labs in minutes.**

`infra-hauler` is a lightweight, high-performance CLI tool designed to automate the deployment of Rancher and RKE2 clusters across multiple cloud providers. By wrapping complex automation scripts into a single, portable binary, it eliminates the need for manual script management and configuration overhead.

---

## 📖 Overview

This project is designed to help users quickly set up Rancher and RKE2 clusters across various cloud providers (AWS, DigitalOcean, etc.). The tool uses an interactive CLI menu to guide users through the process of:
- Creating Rancher management clusters.
- Provisioning downstream RKE2 clusters.
- Automating the installation of necessary dependencies (like `whiptail`, `kubectl`, etc.).

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

2. ** Run the tool:**
   ```bash
   ./infra-hauler-linux

3. **(Optional) Move to your PATH: **
  ```bash
  sudo mv infra-hauler-linux /usr/local/bin/infra-hauler
  infra-hauler



### 🌟 Key Features

* **Interactive UI:** Uses an intuitive terminal-based menu (Whiptail) for a seamless, guided user experience.
* **Multi-Cloud Support:** Provision clusters on **AWS** and **DigitalOcean** with unified commands.
* **Zero Script Management:** All Bash logic is embedded inside the compiled Go binary—no more managing a folder of loose `.sh` files.
* **Smart Dependencies:** Automatically detects your OS (Ubuntu/Debian, RHEL/Fedora, openSUSE, or macOS) and installs required system tools if they are missing.
* **Clean Execution:** Scripts are extracted to a secure temporary directory during runtime and wiped immediately after execution.

---

### 🛠️ Supported Deployments

| Deployment Type | Cloud Provider | Description |
| :--- | :--- | :--- |
| **Rancher Local** | AWS | Spin up a Rancher management server on a single EC2 instance. |
| **Rancher Local** | DigitalOcean | Fast provisioning of a Rancher management server on a Droplet. |
| **Downstream RKE2** | DigitalOcean | Deploy a production-ready RKE2 downstream cluster. |
| **Downstream RKE2** | AWS | Scalable RKE2 clusters deployed into your existing VPC. |

---

### 📦 Version Archive

Need a specific older version? You can find all historical binaries, source code snapshots, and detailed changelogs in our official repository archive:

👉 [**View All Previous Releases**](https://github.com/abhishekhpatil10/infra-hauler/releases)

---

### 📂 The repository structure

``` 
.
├── Scripts/                 # Main directory to modules
│   ├── digital_ocean.sh     # Module to deploy a Rancher upstream cluster on Digital Ocean.
│   ├── infra-hauler.sh      # Main script that provides TUI for user to select an environment to deploy
└── README.md                # Project documentation
```

### 🤝 Contributing

We welcome contributions to expand the cloud ecosystem! To add a new provider (like GCP or Azure) or a new cluster type:

1. **Fork** the repository and create your feature branch.
2. Add your new `.sh` script to the `Script/` folder.
3. Ensure your script uses the `$SCRIPT_DIR` variable to locate sibling scripts.
4. Update the main menu in `Script/infra-hauler.sh` to include your new option.
5. Submit a **Pull Request** for review.
---


*Maintained by [Abhishek Patil](https://github.com/abhishekhpatil10)*



















