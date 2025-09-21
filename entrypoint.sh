#!/bin/bash
set -e

if [ -z "$EXERCISM_TOKEN" ]; then
    echo "EXERCISM_TOKEN is not set!"
    exit 1
fi

# Configure Exercism if not already
mkdir -p /root/exercism
if [ ! -f /root/exercism/.exercism.json ]; then
    /root/bin/exercism configure --token="$EXERCISM_TOKEN" --workspace="/root/exercism"
fi

exec "$@"
