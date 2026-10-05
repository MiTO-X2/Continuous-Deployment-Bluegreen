#!/usr/bin/env bash

echo "Preparing your environment (installing tools, building v1 image)..."

while true; do
    if [ -f /tmp/.tutorial_ready ]; then
        echo "Environment ready."
        exit 0
    fi

    if [ -f /tmp/.tutorial_failed ]; then
        echo "Environment setup failed."
        exit 1
    fi

    sleep 2
done