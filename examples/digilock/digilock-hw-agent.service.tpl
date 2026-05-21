[Unit]
Description=Digilock Hardware Agent
After=local-fs.target

[Service]
Type=simple
User=root
Group=root
RuntimeDirectory=digilock-hw
RuntimeDirectoryMode=0755
Restart=always
RestartSec=1
Environment="DIGILOCK_API_BIND=$API_BIND"
EnvironmentFile=-/run/digilock/runtime.env
ExecStart=/usr/local/bin/digilock-agent-launcher
StandardError=journal

[Install]
WantedBy=multi-user.target