[Unit]
Description=Kiosk Wayland Session
Conflicts=getty@tty1.service
After=getty@tty1.service
After=multi-user.target

[Service]
User=$KIOSK_USER
TTYPath=/dev/tty1
Environment="XDG_RUNTIME_DIR=/run/kiosk"
RuntimeDirectory=kiosk
RuntimeDirectoryMode=0700
Restart=always
RestartSec=2
ExecStart=/usr/bin/cage -- $KIOSK_APP
StandardError=journal

[Install]
WantedBy=default.target
