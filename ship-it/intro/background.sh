#!/usr/bin/env bash
set -e

# Wait for assets to be copied (max 30 seconds)
for i in {1..30}; do
  [ -d ~/tutorial ] && break
  sleep 1
done

# If still not there, create basic structure
if [ ! -d ~/tutorial ]; then
  mkdir -p ~/tutorial/{app,ci,deploy}
fi

need=""
command -v python3 >/dev/null || need="$need python3"
command -v curl >/dev/null || need="$need curl"
command -v git >/dev/null || need="$need git"
if [ -n "$need" ]; then
  apt-get update -qq && apt-get install -y -qq $need >/dev/null
fi

# Only chmod if files exist
if [ -d ~/tutorial/ci ]; then
  chmod +x ~/tutorial/ci/*.sh 2>/dev/null || true
fi
if [ -d ~/tutorial/deploy ]; then
  chmod +x ~/tutorial/deploy/*.sh 2>/dev/null || true
fi
[ -f ~/tutorial/new_change.sh ] && chmod +x ~/tutorial/new_change.sh

cd ~/tutorial 2>/dev/null || cd /root
git config --global user.email "you@devops.tutorial"
git config --global user.name "DevOps Learner"
git init -q 2>/dev/null || true
printf '.prod/\n' > .gitignore
git add -A && git commit -qm "v1: initial release" 2>/dev/null || true

docker pull -q python:3.12-alpine >/dev/null 2>&1 || true
docker pull -q nginx:alpine >/dev/null 2>&1 || true
[ -d app ] && docker build -q -t app:1 app >/dev/null 2>&1 || true

touch /tmp/.tutorial_ready