#!/bin/bash
curl -s localhost:8080/version | grep -q '"version": "2"' && \
curl -s localhost:8080/version | grep -q '"color": "green"'