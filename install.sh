#!/bin/sh
set -e         # Exit on error

# make the executable
as -o tmp.o main.s
ld -o main.out tmp.o
rm tmp.o

echo '#!/bin/sh' > musicbox.tmp
echo 'sudo pkill -f main.out || true' >> musicbox.tmp
echo "sudo nice -n -20 \"$(pwd)/main.out\"" >> musicbox.tmp
chmod +x musicbox.tmp
(sudo rm /usr/bin/musicbox || true) >/dev/null 2>&1
sudo mv musicbox.tmp /usr/bin/musicbox
echo "Installed musicbox to /usr/bin/musicbox"

echo "Creating service if it doesn't exist ..."

if [ ! -f /etc/systemd/system/musicbox.service ]; then
    echo "[Unit]" > musicbox.service.tmp
    echo "Description=Musicbox" >> musicbox.service.tmp
    echo "[Service]" >> musicbox.service.tmp
    echo "ExecStart=/usr/bin/musicbox" >> musicbox.service.tmp
    echo "Restart=always" >> musicbox.service.tmp
    echo "User=root" >> musicbox.service.tmp
    echo "[Install]" >> musicbox.service.tmp
    echo "WantedBy=multi-user.target" >> musicbox.service.tmp
    sudo mv musicbox.service.tmp /etc/systemd/system/musicbox.service
    echo "Created service at /etc/systemd/system/musicbox.service"
else
    echo "Service already exists at /etc/systemd/system/musicbox.service"
fi 

echo "Enabling service ..."
sudo systemctl enable musicbox
echo "Enabled service"

echo "Starting service ..."
sudo systemctl start musicbox
echo "Started service"

echo "Done"
