#!/usr/bin/env bash
echo "Preparing your environment (installing tools, building v1 image)..."
while [ ! -f /tmp/.tutorial_ready ]; do sleep 2; done
echo "Environment ready."