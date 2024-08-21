# Step 1 - Use an official Python runtime as a parent image. 
# Using `python:3.8-slim` for a lightweight Python 3.8 environment.
FROM python:3.8-slim

# Step 2 - Set the working directory in the container to `/app`. 
# This will be the root directory for your application inside the container.
WORKDIR /app

# Step 3 - Copy all application files from the current directory on the host 
# machine into the `/app` directory in the container.
COPY  . .

# Install system dependencies and ODBC driver:
# 1. Update the package list.
# 2. Install necessary packages for ODBC and PostgreSQL development.
# 3. Add Microsoft’s signing key and SQL Server's repository to install the ODBC driver.
# 4. Install the ODBC driver for SQL Server.
# 5. Clean up unnecessary packages to reduce the image size.
RUN apt-get update && apt-get install -y \
    unixodbc unixodbc-dev odbcinst odbcinst1debian2 libpq-dev gcc && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -qO- https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    apt-get purge -y --auto-remove wget && \
    apt-get clean

# Install the latest version of pip and setuptools.
RUN pip install --upgrade pip setuptools

# Step 4 - Install the Python packages listed in `requirements.txt` 
# to ensure the application has all the dependencies it needs.
RUN pip install -r requirements.txt

# Install additional Python packages for Azure integration, specifically for 
# managing identities and secrets in Azure Key Vault.
RUN pip install azure-identity azure-keyvault-secrets

# Step 5 - Expose port 5000 to allow traffic to the application. 
# This is necessary for the application to be accessible from outside the container.
EXPOSE 5000

# Step 6 - Define the command to run the application when the container starts.
# It will execute `python app.py` to launch the application.
CMD ["python", "app.py"]
