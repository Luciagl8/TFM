# Introduction 
This repository consists of the scripts developed for the Master's final project: "DESIGN AND DEPLOYMENT OF A HYBRID AND MULTICLOUD ENVIRONMENT WITH CENTRALISED SECURITY MANAGEMENT USING AZURE SERVICES" of the UPM Cybersecurity Master.

The proposal of this work is to develop a cloud environment with the security management centralized. This scenario will be composed by elements in different clouds (multi-cloud) together with on-premise elements (hybrid). To centralize the security of the environment, Azure cloud tools will be used. In addition to centralizing all the security, a complete study will be carried out to identify the best solutions, within the environment provided by Azure, to be applied to each deployed element, establishing a security strategy.
Related to that, the main objectives of this project are: to stablish knowledge of cybersecurity applied to cloud, to understand the functionality of the cloud in order to deploy the necessary elements to do a proof of concept, and to implement a prototype of the idea.
To meet those objectives, the following steps have been set:
o	Conduct a survey of the available technologies identifying the different mechanisms and solutions applicable to the scenario.
o	Find the tools to centralize the security management of diverse clouds and on-premise environments in the Azure cloud.
o	Design and prototype the model and architecture of the different elements chosen and the security strategy to perform a proof of concept.
o	Automate as much as possible the deployment of the environment with different IaC templates.
o	Write a user manual with the minimum requirements needed to be able to replicate the scenario.
o	Draw conclusions from the work done and plan future actions.


# Getting Started
This project has 7 folders with de code and manuals necesaries to deploy the environment

# Requirements
- Azure CLI version 2.15.0 and above
- AWS CLI
- wget and kubectl installed and added to PATH
- AWS IAM Authenticator and Helm installed (both binaries in PATH)
- An existing ssh key in ~/.ssh
    Create one pair with the next command:
    >>> ssh-keygen -t ed25519 -C <email>
- An AWS account
- An Azure account

