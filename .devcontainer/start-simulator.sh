#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

echo "Starting LUX HPC EDU Simulator..."

# Wait for Docker to become available
for attempt in {1..30}; do
    if docker info >/dev/null 2>&1; then
        break
    fi
    sleep 2
done

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker is not available."
    exit 1
fi

# Initialize shared volumes using the login node
echo "Starting login node..."
docker compose up -d login01

# Start compute nodes sequentially
echo "Starting compute nodes..."
docker compose --parallel 1 up -d \
    compute001 compute002 compute003 compute004

# Configure the SSH connection
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

# Add SSH alias only if it does not already exist
if ! grep -Eq '^[[:space:]]*Host[[:space:]]+lux-ai-hpc([[:space:]]|$)' "$HOME/.ssh/config"; then

    cat >> "$HOME/.ssh/config" <<'EOF'

Host lux-ai-hpc
    HostName 127.0.0.1
    User learner
    Port 2222
EOF

fi

# Wait for the SSH server
for attempt in {1..30}; do
    if ssh-keyscan -T 2 -p 2222 127.0.0.1 >/dev/null 2>&1; then

        echo ""
        echo "========================================"
        echo "LUX HPC EDU Simulator is ready."
        echo ""
        echo "Connect using:"
        echo "  ssh lux-ai-hpc"
        echo "========================================"
        echo ""

        exit 0
    fi

    sleep 2
done

echo "ERROR: SSH server did not become available."
exit 1
