#!/usr/bin/env bash

echo "========================================"
echo "Updating Ubuntu system packages"
echo "========================================"

sudo apt update
sudo apt upgrade -y


echo "========================================"
echo "Removing unofficial Docker packages"
echo "========================================"

sudo apt remove -y docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc || true


echo "========================================"
echo "Installing required dependencies"
echo "========================================"

sudo apt install -y ca-certificates curl


echo "========================================"
echo "Adding Docker GPG key"
echo "========================================"

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc


echo "========================================"
echo "Adding Docker repository"
echo "========================================"

UBUNTU_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $UBUNTU_CODENAME
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF


echo "========================================"
echo "Updating package index with Docker repo"
echo "========================================"

sudo apt update


echo "========================================"
echo "Installing Docker Engine"
echo "========================================"

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo "========================================"
echo "Adding current user to docker group"
echo "========================================"

if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi

sudo usermod -aG docker $USER


echo "========================================"
echo "Installing uv (Python package manager)"
echo "========================================"

curl -LsSf https://astral.sh/uv/install.sh | sh


echo "========================================"
echo "Installation complete"
echo "========================================"

echo "Verify Docker installation:"
echo "  docker --version"
echo "  docker compose version"
echo "  docker run hello-world"

echo ""
echo "Verify uv installation:"
echo "  source \$HOME/.local/bin/env"
echo "  uv --version"
