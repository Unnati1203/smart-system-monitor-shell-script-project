#!/bin/bash

echo "Installing Smart System Monitor..."

chmod +x monitor.sh
chmod +x config.sh

# Add cron job
(crontab -l 2>/dev/null; echo "*/5 * * * * $(pwd)/monitor.sh") | crontab -

echo "Setup complete!"
echo "Script will run every 5 minutes."
