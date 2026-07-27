Build an image that boots directly into Cage/Chromium and opens your app on localhost.

This example uses the standard apt model:

* Bake your apt key into the image
* Bake your apt repository source into the image
* Install your app package at build time
* Later update with apt on the running device

Very simple setup

1. Put your public apt key in:
	./examples/digilock-webkiosk/keyrings/digilock-kiosk-archive-keyring.asc

2. Edit:
	./examples/digilock-webkiosk/config/kiosk.yaml

3. Set these values in the kiosk section:
	app_pkg        package name to install
	repo_url       apt repo URL
	repo_suite     apt suite (example: stable)
	repo_component apt component (example: main)
	port           localhost port used by your web app

4. Build image:

rpi-image-gen build -S ./examples/digilock-webkiosk/ -c kiosk.yaml

How updates work after boot

sudo apt update
sudo apt install --only-upgrade <your-package>

Notes

* This layer writes /etc/apt/sources.list.d/digilock-kiosk.sources
* This layer copies key to /etc/apt/keyrings/digilock-kiosk-archive-keyring.asc
* Your app package must start a local web server on the configured port
