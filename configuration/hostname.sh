#!/bin/sh
#/usr/lib/mender-configure/apply-device-config.d


if [ $# -ne 1 ]; then
    echo "Must be invoked with exactly one argument: The JSON configuration." 1>&2
    exit 2
fi

CONFIG="$1"
echo $CONFIG

if ! [ -e "$CONFIG" ]; then
    echo "Error: $CONFIG does not exist." 1>&2
    exit 1
fi

NEW_HOSTNAME="$(jq -r -e '."hostname"' < "$CONFIG")"

return_code=$?
echo $return_code

case $return_code in
    0)
        :
        ;;
    1)
        echo "No hostname configuration found." >&2
        echo 0
        ;;
    *)
        exit $return_code
        ;;
esac

echo $NEW_HOSTNAME > hostname

return_code=$?
if [ $return_code -ne 0 ]; then
    echo "Hostname change failed" >&2
fi

CURRENT_HOSTNAME=$(head -n 1 /etc/hostname)
echo "current hostname: "
echo $CURRENT_HOSTNAME
echo "new hostname: "
echo $NEW_HOSTNAME

if [ $CURRENT_HOSTNAME != $NEW_HOSTNAME ]; then
    echo "different hostnames detected. updating..." >&2
fi

exit $return_code
