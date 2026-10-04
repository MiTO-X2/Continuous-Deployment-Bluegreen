#!/usr/bin/env bash
set -e

need=""
command -v python3 >/dev/null || need="$need python3"
command -v curl   >/dev/null || need="$need curl"
command -v git    >/dev/null || need="$need git"
if [ -n "$need" ]; then
  apt-get update -qq && apt-get install -y -qq $need >/dev/null
fi

chmod +x ~/tutorial/ci/*.sh ~/tutorial/deploy/*.sh ~/tutorial/new_change.sh
cd ~/tutorial
git config --global user.email "you@devops.tutorial"
git config --global user.name "DevOps Learner"
git init -q
printf '.prod/\n' > .gitignore
git add -A && git commit -qm "v1: initial release"

docker pull -q python:3.12-alpine >/dev/null 2>&1 || true
docker pull -q nginx:alpine >/dev/null 2>&1 || true
docker build -q -t app:1 app >/dev/null

touch /tmp/.tutorial_ready