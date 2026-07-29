Build an image that boots directly into Cage/Chromium and opens Jellyfin on localhost.

This example uses the standard apt model:

* Bake your apt key into the image
* Bake your apt repository source into the image
* Install the Jellyfin package at build time
* Later update with apt on the running device

What is preconfigured

* app_pkg: jellyfin
* repo_url: https://repo.jellyfin.org/debian
* repo_suite: trixie
* repo_component: main
* port: 8096
* url: http://localhost:8096/web/index.html
* system_part_size: 2200M

Very simple setup

1. The Jellyfin apt key is already provided in:
	./examples/digilock-webkiosk/keyrings/digilock-kiosk-archive-keyring.asc

2. Edit:
	./examples/digilock-webkiosk/config/kiosk.yaml

3. Optionally adjust these values in the kiosk section:
	repo_suite     apt suite (default: trixie)
	url            explicit URL loaded by Chromium
	port           localhost port used by Jellyfin (default: 8096)

4. Build image:
```
cd ~/rpi-image-gen
./rpi-image-gen build -S ./examples/digilock-webkiosk/ -c kiosk.yaml
```
How updates work after boot

sudo apt update
sudo apt install --only-upgrade jellyfin

Notes

* This layer writes /etc/apt/sources.list.d/digilock-kiosk.sources
* This layer copies key to /etc/apt/keyrings/digilock-kiosk-archive-keyring.asc
* Jellyfin must be reachable on the configured localhost URL

To flash to another raspberry pi run 
```
sudo rpi-imager --cli /home/pi/rpi-image-gen/work/image-digilock-kiosk-image/digilock-kiosk-image.img /dev/sdX
```