Build an image that boots directly into Cage/Chromium and opens your app at localhost.

This example is intentionally simple:

* One place to select the app package installed at build time
* One place to set the localhost port used by the browser
* One systemd service that always starts kiosk mode at boot

How to use

1. Edit ./examples/digilock-webkiosk/config/kiosk.yaml
2. Set packages.app to your package name (or use local .deb path)
3. Set kiosk.port to your app port
4. Build image:

rpi-image-gen build -S ./examples/digilock-webkiosk/ -c kiosk.yaml

Update model (Jellyfin style)

To update in the field with apt, your app must come from an apt repository
configured on the device (public or private).

Then updates are as simple as:

sudo apt update
sudo apt install --only-upgrade <your-package>

If you only install a local .deb at image build time and do not configure a
repository, apt cannot discover newer versions automatically.
