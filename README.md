## What is infra-hauler? 
Infra-hauler goes beyond standard Infrastructure as Code (IaC). This tool enables support engineers to automate test lab creation with significantly greater granularity. 

## 📚 Overview 

* The goal of this project is to reduce the operational overhead of running Terraform directly by offering an interactive, opinionated, and repeatable workflow for lab provisioning.
* This repository provides a shell script–based automation layer on top of existing Terraform modules to simplify and standardize the creation of Rancher test labs across multiple cloud providers such as AWS and DigitalOcean. 
* Using this automation, users can quickly spin up, customize, and tear down Rancher environments for testing, validation, demos, or learning—without deep Terraform knowledge.
* The script handles input collection, environment setup, and execution of the appropriate Terraform configurations, making lab creation faster, safer, and more consistent.


## 📂 The repository structure

``` 
.
├── Scripts/                 # Main directory to modules
│   ├── digital_ocean.sh     # Module to deploy a Rancher upstream cluster on Digital Ocean.
│   ├── infra-hauler.sh      # Main script that provides TUI for user to select an environment to deploy
└── README.md                # Project documentation
```
