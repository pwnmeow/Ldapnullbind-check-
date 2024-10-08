#!/bin/bash

# Check if subnet argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi

# Subnet to scan
SUBNET="$1"

echo "Checking LDAP anonymous login on subnet $SUBNET..."

# Loop over each IP in the subnet generated by prips
for ip in $(prips "$SUBNET"); do
    echo "Checking $ip..."

    # Attempt an anonymous bind using ldapsearch
    ldapsearch -x -H ldap://$ip -b "" -s base "(objectclass=*)" -o ldif-wrap=no > /dev/null 2>&1

    # Check the exit status of ldapsearch to determine if anonymous login is enabled
    if [ $? -eq 0 ]; then
        echo "$ip: Anonymous login ENABLED"
    else
        echo "$ip: Anonymous login DISABLED or No response"
    fi
done

echo "LDAP anonymous login check completed for subnet $SUBNET."
