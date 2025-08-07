#!/bin/bash

# === CONFIGURABLE ===
TOKEN="9k8MLjxY8IWixZbyn/qNTKhupX/a0V3TmTQUnpIC/UE="

# === INSTALL DOCKER ===
echo "[+] Installing Docker..."
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# === LANCER TRAFFMONETIZER ===
echo "[+] Launching TraffMonetizer container..."
sudo docker run -d \
  --restart always \
  --name traffmonetizer \
  traffmonetizer/cli start accept --token "$TOKEN"

echo "[✓] Installation terminée. Le conteneur est lancé."
