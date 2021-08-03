#!/bin/sh

# Example script called by Mender client to collect device identity data. The
# script needs to be located at
# $(datadir)/mender/identity/mender-device-identity path for the agent to find
# it. The script shall exit with non-0 status on errors. In this case the agent
# will discard any output the script may have produced.
#
# The script shall output identity data in <key>=<value> format, one
# entry per line. Example
#
# $ ./mender-device-identity
# mac=de:ad:ca:fe:00:01
# cpuid=1112233
#
# The example script collects the MAC address of a network interface with the
# type ARPHRD_ETHER and it will pick the interface with the lowest ifindex
# number if there are multiple interfaces with that type. The identity data is
# output in the following format:
#
# mac=00:01:02:03:04:05
#

# This file is located in /usr/share/mender/identity/ directory as filename
# mender-device-identity

set -ue

SCN=/sys/class/net
min=65535
arphrd_ether=1
ifdev=

# find iface with lowest ifindex, skip non ARPHRD_ETHER types (lo, sit ...)
for dev in $SCN/*; do
    if [ ! -f "$dev/type" ]; then
        continue
    fi

    iftype=$(cat $dev/type)
    if [ $iftype -ne $arphrd_ether ]; then
        continue
    fi

    # Skip dummy interfaces
    if echo "$dev" | grep -q "$SCN/dummy" 2>/dev/null; then
	continue
    fi

    idx=$(cat $dev/ifindex)
    if [ $idx -lt $min ]; then
        min=$idx
        ifdev=$dev
    fi
done


echo "finding device name" >&2

# Method 1
# Save device name at location /data/mender/device-name. Create this file
# before commissioning the device. Or re-commission after adding this file.

# DEVICE_NAME=$(head -n 1 /data/mender/device-name) || DEVICE_NAME=0


# Method 2
# Use mender configuration file to add device name. This configuration is editable
# from web interface as well. Method 1 avoids the chances of accidental configuration
# changes as it cannot be changed from web interface

# CONFIG_PATH="device-config.json"
CONFIG_PATH="/data/mender-configure/device-config.json"
# DEVICE_NAME="$(jq -r -e '."device_name"' < "$CONFIG_PATH")" || DEVICE_NAME=0

# Method 3
# First check in /data/mender/device-name then check in configuration file
# If both fails, ignore the device_name in identity

DEVICE_NAME=$(head -n 1 /data/mender/device-name) || "$(jq -r -e '."device_name"' < "$CONFIG_PATH")" || DEVICE_NAME=0


if [ -z "$ifdev" ]; then
    echo "no suitable interfaces found" >&2
    exit 1

else
    echo "using interface $ifdev" >&2
    # grab MAC address
    echo "mac=$(cat $ifdev/address)"
    if [ $DEVICE_NAME != 0 ]; then
        echo "device_name=$DEVICE_NAME"
    fi
fi
