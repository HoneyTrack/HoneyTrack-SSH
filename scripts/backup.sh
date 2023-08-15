#!/bin/bash

# Specify the base directory
LOGS_DIRECTORY="/home/auti/HoneyTrack-Logs/"
BASE_DIRECTORY="/home/auti/HoneyTrack-Backups/"

# Get today's date in dd-mm-yy format
TODAY=$(date +'%d-%m-%y')

# Create the complete folder path
FOLDER_PATH="${BASE_DIRECTORY}${TODAY}"

# Check if the folder already exists
if [ ! -d "$FOLDER_PATH" ]; then
    # Create the folder
    mkdir -p "$FOLDER_PATH"
    echo "Folder '$FOLDER_PATH' created successfully."
else
    echo "Folder '$FOLDER_PATH' already exists."
fi

mv $LOGS_DIRECTORY $FOLDER_PATH

# to add cronjob,
# crontab -e
# 30 13 * * *   /home/auti/Desktop/Code/Scripts/backup.sh