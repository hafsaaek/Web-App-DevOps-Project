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

### Part 2: Containerisation with Docker Control
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

### Part 9: AKS integtation with Azure Keyvault for secrets management
1. Created a Azure Keyvault and assigned the Key Vault Administrator role to my Microsoft Entra ID user to grant myself the necessary permissions for managing secrets within the Key Vault.
2. Following this, I created four secrets in the Key Vault to secure the credentials used within the application to connect to the backend database. These secrets include the server name, server username, server password, and the database name and ensured that the values of these secrets are set to the hardcoded values from the application code.
3. To integrate Azure Key vault with the AKS cluster, a system managedidentity was leveraged for secure secrets retrieval, and the application code was ammended to refelct this change as well as depencies to make the docker image and requirement files.
