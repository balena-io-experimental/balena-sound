if [[ -d "/root/.local/share/Plexamp/Settings" ]]; then
    echo "Plexamp appears to be already configured, skipping..."
    exit 1
fi

echo "When prompted, enter your claim token from https://plex.tv/claim"
echo "Plexamp will start after entering, simply press control+c and restart the plex service to continue."

cd /opt/plexamp/plexamp/

node js/index.js