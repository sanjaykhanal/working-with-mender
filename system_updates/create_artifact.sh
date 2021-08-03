IP_ADDRESS="192.168.10.104"
USER="pi"
DEVICE_TYPE="raspberrypi4"
SSH_ARG="-p 22"
ARTIFACT_VERSION="system-v1.1"
OUTPUT_NAME="system-v1-1.mender"


mender-artifact write rootfs-image -f ssh://"${USER}@${IP_ADDRESS}" -t "${DEVICE_TYPE}" -n "${ARTIFACT_VERSION}" -o "${OUTPUT_NAME}" -S "${SSH_ARG}"
