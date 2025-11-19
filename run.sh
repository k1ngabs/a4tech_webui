#!/bin/bash

echo "Select an option to run the Flutter app:"
echo "1. Run on Linux Desktop"
echo "2. Run on Web Server"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Running on Linux Desktop..."
        fvm flutter run -d linux
        ;;
    2)
        echo "Running on Web Server..."
        fvm flutter run -d web-server
        ;;
    *)
        echo "Invalid choice. Please enter 1 or 2."
        exit 1
        ;;
esac
