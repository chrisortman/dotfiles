#!/usr/bin/env bash

#MISE description="Script to install Oracle Instant Client (ARM version) on Ubuntu 24 LTS"

set -e
 
#instantclient-basic-linux.arm64-23.7.0.25.01.zip
#https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basic-linux.arm64-23.7.0.25.01.zip
#https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-sdk-linux.arm64-23.7.0.25.01.zip
#https://download.oracle.com/otn_software/linux/instantclient/1927000/instantclient-basic-linux.arm64-19.27.0.0.0dbru.zip
# Variables
ORACLE_BASE_URL="https://download.oracle.com/otn_software/linux/instantclient"

# Newer 23  
#ORACLE_VERSION="2370000" # Update this version if needed
CLIENT_VERSION="23_7"
#ARCH="arm64-23.7.0.25.01" # ARM architecture
#
#
# Older 19
ORACLE_VERSION="1927000" # Update this version if needed
CLIENT_VERSION="19_27"
ARCH="arm64-19.27.0.0.0dbru"
DOWNLOAD_DIR="/tmp/oracle_instant_client"

# Dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y libaio1t64 libaio-dev wget unzip

# Create a download directory
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Download Oracle Instant Client files (Basic and SDK)
echo "Downloading Oracle Instant Client files..."
wget "${ORACLE_BASE_URL}/${ORACLE_VERSION}/instantclient-basic-linux.${ARCH}.zip"
wget "${ORACLE_BASE_URL}/${ORACLE_VERSION}/instantclient-sdk-linux.${ARCH}.zip"
wget "${ORACLE_BASE_URL}/${ORACLE_VERSION}/instantclient-tools-linux.${ARCH}.zip"
wget "${ORACLE_BASE_URL}/${ORACLE_VERSION}/instantclient-sqlplus-linux.${ARCH}.zip"

# Extract the downloaded files
echo "Extracting Oracle Instant Client files..."
unzip -o "instantclient-basic-linux.${ARCH}.zip"
unzip -o "instantclient-sdk-linux.${ARCH}.zip"
unzip -o "instantclient-tools-linux.${ARCH}.zip"
unzip -o "instantclient-sqlplus-linux.${ARCH}.zip"

# Move to /opt/oracle
echo "Installing Oracle Instant Client..."
sudo mkdir -p /opt/oracle
sudo mv instantclient_* /opt/oracle/
sudo ln -s /opt/oracle/instantclient_${CLIENT_VERSION} /opt/oracle/instantclient

echo "Patching oracle async library for newer ubuntu system (libaio.so.1)"
sudo ln -sf /usr/lib/aarch64-linux-gnu/libaio.so.1t64 /usr/lib/aarch64-linux-gnu/libaio.so.1

# Configure environment variables
echo "Configuring environment variables..."
echo "export LD_LIBRARY_PATH=/opt/oracle/instantclient:\$LD_LIBRARY_PATH" | sudo tee -a /etc/profile.d/oracle_instant_client.sh
echo "export PATH=/opt/oracle/instantclient:\$PATH" | sudo tee -a /etc/profile.d/oracle_instant_client.sh

# Apply environment variables
source /etc/profile.d/oracle_instant_client.sh

# Verify installation
echo "Verifying Oracle Instant Client installation..."
sqlplus -v

echo "Oracle Instant Client installation (Basic and SDK) completed successfully."

