#!/bin/bash

# Function to get the permanent MAC address of an interface
get_permanent_mac() {
    local iface=$1
    ethtool -P $iface | awk '{print $3}'
}

# Get hostname
hostname=$(hostname)

# Get permanent MAC addresses for WiFi and Ethernet interfaces
wifi_iface=$(iw dev | awk '$1=="Interface"{print $2}')
eth_iface=$(ip link show | awk '$1 == "2:" {print substr($2, 1, length($2)-1)}')

wifi_mac=$(get_permanent_mac $wifi_iface)
eth_mac=$(get_permanent_mac $eth_iface)

# Prompt for CSV file location
read -p "Enter the location of the CSV file (e.g., /mnt/usb/myfile.csv): " csv_file

# Check if the CSV file exists
if [[ ! -f $csv_file ]]; then
    # Create the file and add headers if it doesn't exist
    echo "Hostname,WiFi MAC,Ethernet MAC" > $csv_file
fi

# Append the new entry
echo "$hostname,$wifi_mac,$eth_mac" >> $csv_file

echo "Information successfully appended to $csv_file"
