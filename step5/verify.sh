#!/bin/bash
curl -s localhost:8080/version | grep -q '"version": "3"' && \
curl -s localhost:8080/version | grep -q '"color": "blue"'