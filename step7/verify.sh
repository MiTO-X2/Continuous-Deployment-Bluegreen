#!/bin/bash
curl -s localhost:8080/version | grep -q '"version": "3"' && \
grep -q blue ~/tutorial/.prod/live_color