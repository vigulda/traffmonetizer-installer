#!/bin/bash

# === Vérifie si un token est passé en argument ===
if [ -z "$1" ]; then
  echo "❌ Usage : bash install.sh VOTRE_TOKEN_TRAFFMONETIZER"
  exit 1
fi

TOKEN="$1"

# === Télécharge le script officiel de spiritLHLS ===
echo "[+] Téléchargement du script d'installation..."
curl -L https://raw.githubusercontent.com/spiritLHLS/traffmonetizer-one-click-command-installation/main/tm.sh -o tm.sh

# Vérifie si le téléchargement a réussi
if [ ! -f tm.sh ]; then
  echo "❌ Échec du téléchargement du script."
  exit 1
fi

chmod +x tm.sh

# === Lance le script avec le token donné ===
echo "[+] Lancement du script avec le token fourni..."
sudo bash tm.sh -t "$TOKEN"
