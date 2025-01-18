#!/bin/bash

# Define file paths
TARGET_DIR="/mnt/ssd/GeoLite2_db"
TARGET_FILE="GeoLite2-City.mmdb"

# GitHub API URL to get the latest release data (returns JSON)
GITHUB_API_URL="https://api.github.com/repos/P3TERX/GeoLite.mmdb/releases/latest"

# Get the download URL for the GeoLite2-City.mmdb file from the latest release
DOWNLOAD_URL=$(curl -s "$GITHUB_API_URL" | jq -r '.assets[] | select(.name == "GeoLite2-City.mmdb") | .browser_download_url')

# Check if the download URL is found
if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: Could not find the download URL for GeoLite2-City.mmdb."
  exit 1
fi

# Change to the target directory
cd "$TARGET_DIR" || { echo "Target directory not found."; exit 1; }

# Download the latest GeoLite2-City.mmdb from the dynamically fetched URL
echo "Downloading the latest GeoLite2-City.mmdb..."
curl -L -o "$TARGET_FILE" "$DOWNLOAD_URL"

# Verify download and replace the old file
if [ $? -eq 0 ]; then
    echo "Download completed. The database file has been updated."
else
    echo "Error downloading the GeoLite2 database."
    exit 1
fi