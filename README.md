# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)
- azure-identity==1.15.0 (added following AKS integration with Azure Key Vault)
- azure-keyvault-secrets==4.4.0 (added following AKS integration with Azure Key Vault)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

## Contributors 

- [Hafsa Kahiye]([https://github.com/yourusername](https://github.com/hafsaaek))
- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.

## Documentation of Project How to's

### Part 1: Version Control
1. Cloned fork repo to my local workstation and created a new branch for the purpose of adding a new feature that would allow the application to contain a delivery_date column
2. Code changes were made to the python file and corresponding HTML file and the changes were pushed to the remote repo
3. A pull request was created, once this was reviewed, the feature branch was merged into main
4. It was decided that this new feature was not needed thus, a new branch (revert-delivery-date) was created to revert the changes using git revert <commit-hash>
5. The changes were then pushed to the remote repo and an additional pull request was made which was approved and merged into main.

### Part 2: Containerisation using Docker 
1. Utilised an official Python runtime as a base image as this was most suitable for a flask application (FROM `python:3.8-slim`).
2. Set the working directory in the container (WORKDIR /app)
3. Used the COPY instruction to copy the contents of the local directory into the containers /app directory to ensure that the application code and files are available within the container (COPY  . .)
4. Installed Python Packages from requirements.txt: Install Python packages specified in your requirements.txt file using the command (pip install --trusted-host pypi.python.org -r requirements.txt) to install the packages. The requirements.txt file contains all the packages necessary for running the application successfully (See a list of these requirements in the Prerequisites section above). 
5. Exposed Port 5000: to make he Flask application accessible from outside the container
6. Defined Startup Command by using  the CMD instruction to specify the command that should be executed when the container launches (CMD ["python", "app.py"])
7. Built  docker image using the command 'docker build -t order-list-app .'
8. Ran & initiated a Docker container locally to ensure the application functions correctly within the containerised environment (docker run -p 5000:5000 order-list-app). This mapped port 5000 from your my machine to the container, enabling access to the containerised application from my local development environment. The application was confirmed to be working as expected by visiting  http://127.0.0.1:5000 and interaction  interact with the application within the Docker container. 
    docker run -p 5000:5000 order-list-app # This will give you a background log of the new app running on docker in the container, if you exit i.e. crtll +c, the container stops running
9. Tagged and push docker image to docker hub
    docker tag order-list-app hafsaaek/order-list-app:v1.0 
    docker images order-list-app # To see all tags associated with an image, you can use docker images
10. To verify this, the same image was pulled form docker hub and used ro run a container
    docker pull hafsaaek/order-list-app:v1.0
    docker run -p 5000:5000 hafsaaek/order-list-app:v1.0

### Part 3: AKS Cluster Provisioning using Terraform 
To deploy the containerised application onto a Kubernetes cluster for scalability, a 3 step approach was taken; creating an AKS cluster module, a networking module and integrating the two modules to provision the cluster
#### Part 3.1: Defining Networking Services with IaC (Terraform)
1. Defined the networking module input variables in a variables.tf file (see below). In this file to allow us to configure and customise networking services based on specific requirements (all variable were of type list(string) and created with a default value)
    - A resource_group_name variable that will represent the name of the Azure Resource Group where the networking resources will be deployed in. The variable should be of type string and have a default value.
    - A location variable that specifies the Azure region where the networking resources will be deployed to
    - A vnet_address_space variable that specifies the address space for the Virtual Network (VNet) that will be create later in the main configuration file of this module
2. Definde Networking resources & NSG Rules:
- This included creating an Azure Resource Group, a VNet, two subnets (for the control plane and worker nodes) and a Network Security Group (NSG). Within the NSG, two inbound rules were defined: one to allow traffic to the kube-apiserver (named kube-apiserver-rule) and one to allow inbound SSH traffic (named ssh-rule) to allow inbound traffic from the local public IP address.
3. Defined the output variables in an outputs.tf configuration file to enable access and utilize information from the networking module. These variables will be used to provision the networking services used by the AKS cluster later on, when provisioning the cluster module. The output variables are:
    - A vnet_id variable that will store the ID of the previously created VNet. This will be used within the cluster module to connect the cluster to the defined VNet.
    - A control_plane_subnet_id variable that will hold the ID of the control plane subnet within the VNet. This will be used to specify the subnet where the control plane components of the AKS cluster will be deployed to.
    - A worker_node_subnet_id variable that will store the ID of the worker node subnet within the VNet. This will be used to specify the subnet where the worker nodes of the AKS cluster will be deployed to.
    - A networking_resource_group_name variable that will provide the name of the Azure Resource Group where the networking resources were provisioned in. This will be used to ensure the cluster module resources are provisioned within the same resource group.
    - A aks_nsg_id variable that will store the ID of the Network Security Group (NSG). This will be used to associate the NSG with the AKS cluster for security rule enforcement and traffic filtering.
4. Initialise the Networking module to ensure it is ready to use 
- terraform init
#### Part 3.2: Defining an AKS Cluster Services with IaC (Terraform)
1. Define the input variables for the AKS Cluster module in a variables.tf configuration file.
    - A aks_cluster_name variable that represents the name of the AKS cluster
    - A cluster_location variable that specifies the Azure region where the AKS cluster will be deployed to
    - A dns_prefix variable that defines the DNS prefix of cluster
    - A kubernetes_version variable that specifies which Kubernetes version the cluster will use
    - A service_principal_client_id variable that provides the Client ID for the service principal associated with the cluster
    - A service_principal_secret variable that supplies the Client Secret for the service principal
- Additionally, the output variables from the networking module as input variables for this module were added:
    - The resource_group_name variable
    - The vnet_id variable
    - The control_plane_subnet_id variable
    - The worker_node_subnet_id variable
2. Defined the the necessary Azure resources for provisioning an AKS cluster within the cluster modules main.tf configuration file. This includes creating the AKS cluster, specifying the node pool and the service principal by using the input variables defined in the previous step to specify the necessary arguments.
3. Defined the output variables for the AKS Cluster module inside the outputs.tf configuration file with the following output variables:
    - A aks_cluster_name variable that will store the name of the provisioned cluster
    - A aks_cluster_id variable that will store the ID of the cluster
    - A aks_kubeconfig variable that will capture the Kubernetes configuration file of the cluster. This file is essential for interacting with and managing the AKS cluster using kubectl
#### Part 3.3: Creating the AKS Cluster using the modules created in steps 3.1 & 3.2 
1. Integrate the Networking module (See main.tf file)
2. Integrate the AKS cluster (See main.tf file)
3. Initialise the terraform project, plan it and debug any issues that arise i.e. see below  (terraform init, terraform plan)
    - Assign a contribute rule for the new app registration (service principal)
        az role assignment create --assignee <service-principal-client-id> --role Contributor --scope /subscriptions/<subscription-id>
        az role assignment list --assignee <service-principal-client-id> --all #To check role for this Service Principle
    - Make sure all the resources are correctly named everywhere
4. Apply the configuration to provision the cluster (terraform apply)
5. Retrieve the kubeconfig file once the AKS cluster has been provisioned to copy into local machine. This configuration file allows you to connect to the AKS cluster securely. Connect to the newly created cluster to ensure that the provisioning process was successful and the cluster is operational.
    - az aks get-credentials --resource-group <resource-group-name>  --name <AKS-Cluster-Name> # Get credentials and merges in your home directory
    - cat ~/.kube/config # Verifies these credentials are there:
6. Interact and access the provisioned AKS cluster using kubectl e.g.:
    - kubectl get nodes
    - kubectl config get-contexts

### Part 4: Containerisation using Docker 
1. Define K8s Deployment Manifest with the following deployment specs:
    - Labels: flask-app
    - Replicas: 2 for scalability.
    - Container Image: Docker Hub.
    - Port: 5000 for AKS cluster.
    - Strategy: Rolling Updates.
2. Define K8s Deployment Manifest with the following service specs:
    - Type: ClusterIP
    - Name: flask-app-service
    - Selector: Match app: flask-app.
    - Protocol: TCP, Port: 80, TargetPort: 5000.
3. Deploy to AKS
    3.1 Ensure Correct Context
    - kubectl config get-contexts
    - kubectl config use-context <your-aks-context-name>
    3.2 Apply Manifest and Monitor
    - Apply manifest: kubectl apply -f application-manifest.yaml
    - Monitor deployment: kubectl get pods -w.
    3.3 Verify Deployment Status
    - Check pods: kubectl get pods.
    - Check services: kubectl get services.
4. Testing with Port Forwarding
    4.1 Verify Pod and Service Status and ensure pods are running, services exposed.
    4.2 Initiate Port Forwarding
    - kubectl port-forward <pod-name> 5000:5000.
    4.3 Test Application Locally
    - Access at http://127.0.0.1:5000.

### Part 9: AKS integtation with Azure Keyvault for secrets management
1. Created a Azure Keyvault and assigned the Key Vault Administrator role to my Microsoft Entra ID user to grant myself the necessary permissions for managing secrets within the Key Vault.
2. Following this, I created four secrets in the Key Vault to secure the credentials used within the application to connect to the backend database. These secrets include the server name, server username, server password, and the database name and ensured that the values of these secrets are set to the hardcoded values from the application code.
3. To integrate Azure Key vault with the AKS cluster, a system managedidentity was leveraged for secure secrets retrieval, and the application code was ammended to refelct this change as well as depencies to make the docker image and requirement files.
