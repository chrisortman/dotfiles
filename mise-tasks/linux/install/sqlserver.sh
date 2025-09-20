#!/usr/bin/env bash

#MISE description="Installs packages needed for interacting with Microsoft SQL Server. Does not install a database"
#MISE depends=["linux:system-update"]

echo "Updating package lists..."
sudo apt-get update

# Pre-reqquisites for msodbc18
echo "Installing prerequisites..."
sudo apt-get install -y curl apt-transport-https gnupg lsb-release

# Add Microsoft GPG key
echo "Adding Microsoft GPG key..."
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg

# Add Microsoft repository
echo "Adding Microsoft repository..."
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Update package lists again
echo "Updating package lists with Microsoft repository..."
sudo apt-get update

# Install ODBC Driver 18
echo "Installing Microsoft ODBC Driver 18 for SQL Server..."
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Optionally install command-line tools (uncomment if needed)
# echo "Installing SQL Server command-line tools..."
# sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18
# echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

# Install unixODBC development headers (useful for development)
echo "Installing unixODBC development headers..."
sudo apt-get install -y unixodbc-dev

