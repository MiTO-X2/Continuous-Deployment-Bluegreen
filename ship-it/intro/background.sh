#!/usr/bin/env bash
set -euo pipefail

echo "Waiting for KillerCoda assets..."

for i in {1..60}; do
    if [ -f ~/tutorial/app/VERSION ]; then
        echo "Assets detected!"
        break
    fi
    sleep 1
done

if [ ! -f ~/tutorial/app/VERSION ]; then
    echo "ERROR: KillerCoda assets were not copied."
    touch /tmp/.tutorial_failed
    exit 1
fi

# Install required tools if they are missing.
need=()

command -v python3 >/dev/null || need+=(python3)
command -v curl >/dev/null || need+=(curl)
command -v git >/dev/null || need+=(git)

if [ "${#need[@]}" -gt 0 ]; then
    apt-get update -qq
    apt-get install -y -qq "${need[@]}" >/dev/null
fi

# Make tutorial scripts executable.
chmod +x ~/tutorial/ci/*.sh 2>/dev/null || true
chmod +x ~/tutorial/deploy/*.sh 2>/dev/null || true
chmod +x ~/tutorial/new_change.sh 2>/dev/null || true

cd ~/tutorial

# Configure Git for the tutorial.
git config --global user.email "you@devops.tutorial"
git config --global user.name "DevOps Learner"

# Ignore runtime state and Python cache files.
cat > .gitignore <<'EOF'
.prod/
__pycache__/
*.pyc
EOF

# Initialize the repository and create the initial release.
git init -q
git add -A
git commit -qm "v1: initial release" || true

# Pre-pull images used later in the tutorial.
docker pull -q python:3.12-alpine >/dev/null 2>&1 || true
docker pull -q nginx:alpine >/dev/null 2>&1 || true

# Build the initial v1 artifact required by Step 3.
echo "Building initial app:1 image..."
docker build -q -t app:1 ~/tutorial/app >/dev/null

# Verify that the initial artifact exists.
docker image inspect app:1 >/dev/null

echo "Initial app:1 image ready."
echo "Setup complete!"

touch /tmp/.tutorial_ready

