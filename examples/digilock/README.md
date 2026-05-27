Build a minimal Raspberry Pi base image with splash screen support.

This example is intentionally basic:

* Minimal kiosk display service only
* No custom OTA updater logic
* Splash support through `rpi-splash-screen`

## Build

```bash
# Optional: regenerate splash from Digilock SVG logo
./examples/digilock/render_splash.sh

rpi-image-gen build -S ./examples/digilock/ -c digilock-kiosk.yaml
```

The config uses `examples/digilock/digilock-splash.tga`.

## What This Example Includes

* Base image from `trixie-minbase-ab.yaml`
* `kiosk-display` app layer that launches Chromium in kiosk mode at `http://127.0.0.1:8080`
* `rpi-splash-screen` extra layer
* Custom splash image path

## What This Example Does Not Include

* App hosting implementation (your app provides `:8080` and `:80`)
* Custom hardware-agent service
* Custom app update service

## Runtime Notes

* Your app should listen on `127.0.0.1:8080` for kiosk display content.
* Your app can listen on `0.0.0.0:80` (or device IP) for network portal access.
* This image does not bind ports `80` or `8080`; those remain available to your app.

## SSH

`trixie-minbase-ab.yaml` already includes OpenSSH via the base layer stack.
No extra SSH layer is required for this example.

SSH login uses the same credentials as `device.user1` in `config/digilock-kiosk.yaml`:

* User: `pi`
* Password: `ChangeMe123!`
