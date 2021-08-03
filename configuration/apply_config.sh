#!/bin/sh
# Script which takes arguments from the configuration and runs COMMAND

if [ $# -ne 1 ]; then
    echo "Must be invoked with exactly one argument: The JSON configuration." 1>&2
    exit 2
fi

CONFIG="$1"

if ! [ -e "$CONFIG" ]; then
    echo "Error: $CONFIG does not exist." 1>&2
    exit 1
fi

ARGUMENTS="$(jq -r -e '."mender-demo-command-wrapper"' < "$CONFIG")"

return_code=$?
case $return_code in
    0)
        # Success, continue below.
        :
        ;;
    1)
        echo "No mender-demo-command-wrapper configuration found." >&2
        exit 0
        ;;
    *)
        exit $return_code
        ;;
esac

some-command "$ARGUMENTS"

return_code=$?
if [ $return_code -ne 0 ]; then
    echo "Applying the command with configuration $ARGUMENTS failed" >&2
fi

exit $return_code
