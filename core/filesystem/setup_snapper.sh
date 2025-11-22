#!/bin/bash
echo "[ADAMANT] Configuring Snapper Safety Net..."

# 1. Create Config
if [ ! -f /etc/snapper/configs/root ]; then
    sudo snapper -c root create-config /
fi

# 2. Set Retention (Keep it clean)
sudo sed -i 's/TIMELINE_LIMIT_HOURLY="[0-9]*"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_DAILY="[0-9]*"/TIMELINE_LIMIT_DAILY="5"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_WEEKLY="[0-9]*"/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_MONTHLY="[0-9]*"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
sudo sed -i 's/TIMELINE_LIMIT_YEARLY="[0-9]*"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

# 3. Enable Timers
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# 4. Set Permissions
sudo chmod a+rx /.snapshots

echo "[SUCCESS] Snapper Secured."
