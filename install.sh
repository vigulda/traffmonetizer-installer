#!/bin/bash

# === 1. Vérifie le token ===
if [ -z "$1" ]; then
  echo "❌ Usage : bash install.sh VOTRE_TOKEN_TRAFFMONETIZER"
  exit 1
fi

TOKEN="$1"
USER_HOME="/home/$USER"

# === 2. Télécharge et exécute tm.sh ===
echo "[+] Téléchargement de TraffMonetizer installer..."
curl -L https://raw.githubusercontent.com/spiritLHLS/traffmonetizer-one-click-command-installation/main/tm.sh -o tm.sh

if [ ! -f tm.sh ]; then
  echo "❌ Échec du téléchargement de tm.sh"
  exit 1
fi

chmod +x tm.sh
echo "[✓] Lancement de tm.sh avec le token..."
sudo bash tm.sh -t "$TOKEN"

# === 3. Crée le script keepalive.sh ===
echo "[+] Création de keepalive.sh..."

cat << 'EOF' > "$USER_HOME/keepalive.sh"
#!/bin/bash
# Simuler une activité CPU légère
openssl speed rsa > /dev/null 2>&1

# Simuler du trafic sortant
curl -s https://example.com > /dev/null

# Log d'activité
echo "[Keepalive] $(date) - CPU + Network OK" >> ~/keepalive.log
EOF

chmod +x "$USER_HOME/keepalive.sh"

# === 4. Configuration crontab (toutes les 5 minutes + au reboot) ===
echo "[+] Ajout de keepalive.sh à la crontab..."

# Nettoie les anciennes lignes si présentes
(crontab -l 2>/dev/null | grep -v keepalive.sh) > /tmp/crontab.tmp || true

# Ajoute les lignes utiles
{
  echo "*/5 * * * * $USER_HOME/keepalive.sh"
  echo "@reboot $USER_HOME/keepalive.sh"
} >> /tmp/crontab.tmp

crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

# === 5. Vérifications post-installation ===
echo "[✓] Vérification de la configuration cron..."

# Vérifie que keepalive est bien dans la crontab
if crontab -l | grep -q "$USER_HOME/keepalive.sh"; then
  echo "✅ keepalive.sh est bien enregistré dans la crontab."
else
  echo "❌ ERREUR : keepalive.sh n'est PAS enregistré dans la crontab."
fi

# Vérifie si cron tourne
if pgrep cron >/dev/null; then
  echo "✅ Le service cron est actif."
else
  echo "❌ Le service cron est inactif. Tentative de redémarrage..."
  sudo service cron restart
fi

# Test d'exécution dans les 2 minutes
echo "⏳ Attente 2 minutes pour vérifier l'exécution de keepalive.sh..."
sleep 120

if grep -q "Keepalive" "$USER_HOME/keepalive.log"; then
  echo "✅ keepalive.sh s'est bien exécuté (log détecté)."
else
  echo "⚠️ Aucune activité détectée dans le log. Vérifie manuellement avec :"
  echo "   tail -f ~/keepalive.log"
fi

# === 6. Fin ===
echo "🎉 Tout est en place."
echo "→ TraffMonetizer tourne en arrière-plan."
echo "→ keepalive.sh est actif toutes les 5 minutes et au reboot."
