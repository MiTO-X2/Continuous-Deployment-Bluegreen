#!/usr/bin/env bash
set -e

cd ~/tutorial

git log --oneline | grep -q "v1: initial release"
git log --oneline | grep -q "release v2"
git log --oneline | grep -q "release v3"
git log --oneline | grep -q "release v4"
git log --oneline | grep -q "release v5"

exit 0