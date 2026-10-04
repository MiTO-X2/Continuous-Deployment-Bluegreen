#!/usr/bin/env bash
set -e

# Wait for assets to be copied by KillerCoda (max 60 seconds)
echo "Waiting for assets to be copied..."
for i in {1..60}; do
  if [ -f ~/tutorial/app/VERSION ]; then
    echo "Assets detected!"
    break
  fi
  sleep 1
done

# If assets still aren't there, create minimal structure to prevent crash
if [ ! -d ~/tutorial ]; then
  echo "Warning: Assets not found, creating minimal structure..."
  mkdir -p ~/tutorial/{app,ci,deploy}
  echo "1" > ~/tutorial/app/VERSION
fi

need=""
command -v python3 >/dev/null || need="$need python3"
command -v curl >/dev/null || need="$need curl"
command -v git >/dev/null || need="$need git"
if [ -n "$need" ]; then
  apt-get update -qq && apt-get install -y -qq $need >/dev/null
fi

# Only chmod if directories exist (they should now)
[ -d ~/tutorial/ci ] && chmod +x ~/tutorial/ci/*.sh 2>/dev/null || true
[ -d ~/tutorial/deploy ] && chmod +x ~/tutorial/deploy/*.sh 2>/dev/null || true
[ -f ~/tutorial/new_change.sh ] && chmod +x ~/tutorial/new_change.sh

cd ~/tutorial 2>/dev/null || cd /root
git config --global user.email "you@devops.tutorial"
git config --global user.name "DevOps Learner"
git init -q 2>/dev/null || true
printf '.prod/\n' > .gitignore
git add -A && git commit -qm "v1: initial release" 2>/dev/null || true

docker pull -q python:3.12-alpine >/dev/null 2>&1 || true
docker pull -q nginx:alpine >/dev/null 2>&1 || true

# Build only if the app directory has content
if [ -f ~/tutorial/app/Dockerfile ]; then
  docker build -q -t app:1 ~/tutorial/app >/dev/null 2>&1 || true
fi

echo "Setup complete!"
touch /tmp/.tutorial_ready