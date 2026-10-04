#!/bin/bash
# Users must still be on v3, and the broken green env must be gone
curl -s localhost:8080/version | grep -q '"version": "3"' && \
! docker ps --format '{{.Names}}' | grep -qx app-green