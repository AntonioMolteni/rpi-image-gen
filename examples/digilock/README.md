Build an offline-first Digilock kiosk image for Raspberry Pi 5.

This starter example extends the base image and installs a small platform split
into two local services:

* `digilock-hw-agent.service`: local hardware adapter process for locks/readers
* `digilock-kiosk.service`: touchscreen kiosk shell (Cage + Chromium)

The kiosk points to a local web app endpoint (`http://127.0.0.1:8080`) so it
still works when internet is unavailable.

This example now supports:

* Immutable base image (OS and platform services stay fixed)
* Pull-based app/hw-agent updates from one or more servers
* Headless provisioning from the boot partition
* Kiosk-on or kiosk-off operation per device

## Build

```bash
# Optional: regenerate splash from Digilock SVG logo
./examples/digilock/render_splash.sh

rpi-image-gen build -S ./examples/digilock/ -c digilock-kiosk.yaml
```

The config uses `examples/digilock/digilock-splash.tga`, generated from
`examples/digilock/digilock_white.svg`.

## Headless Provisioning

Place a file named `digilock.env` in the boot partition (`/boot` or
`/boot/firmware`) before first boot.

Minimal customer input (server only):

```bash
DIGILOCK_UPDATE_BASE_URLS="https://updates.customer-domain.com"
```

Optional installer overrides:

```bash
DIGILOCK_KIOSK_ENABLED=n
DIGILOCK_DEVICE_ID=site-a-door-01
DIGILOCK_UPDATE_CHANNEL=stable
DIGILOCK_UPDATE_BASE_URLS="https://updates-a.example.com https://updates-b.example.com"
DIGILOCK_ENROLL_TOKEN=replace-me
```

With `DIGILOCK_KIOSK_ENABLED=n`, the kiosk UI does not launch and the unit runs
headless (ssh remains available for management).

## Release Update Contract

Updater service (`digilock-updater.timer`) polls configured servers and expects
`manifest.json`:

```json
{
   "version": "2026.05.20.1",
   "agent": {
      "url": "https://updates-a.example.com/releases/2026.05.20.1/digilock-hw-agent-linux-arm64",
      "sha256": "<sha256>"
   },
   "app": {
      "url": "https://updates-a.example.com/releases/2026.05.20.1/kiosk-app.tar.gz",
      "sha256": "<sha256>"
   },
   "deviceConfig": {
       "kiosk_enabled": "y",
       "kiosk_url": "http://127.0.0.1:8080/index.html",
       "api_bind": "127.0.0.1:7080",
       "update_channel": "stable",
       "update_base_urls": "https://updates-a.example.com https://updates-b.example.com"
   }
}
```

The updater downloads artifacts, verifies checksums, then atomically flips
`/opt/digilock/apps/current` and `/opt/digilock/agent/current/digilock-hw-agent`.
It also writes server-managed device settings to `/opt/digilock/state/server.env`,
which are applied automatically on next update cycle.

## Repo Split Recommendation

You should create additional repositories for long-term maintainability:

1. `digilock-hw-agent`
   Local daemon exposing a stable API for lock/card-reader peripherals.
2. `digilock-kiosk-apps`
   Frontend apps (rental, gym, enterprise, etc.) built against the local API.
3. `digilock-sdk`
   API schema, client libraries, app manifest/packaging tooling.
4. `digilock-control-plane`
   Central management backend for provisioning, policy, and app deployment.

## What This Example Includes

* Offline local app root at `/opt/digilock/apps/current`
* Nginx serving app content on `127.0.0.1:8080`
* Hardware agent launcher with fallback stub
* Boot-time config merge from `/etc/digilock/default.env` + `/boot*/digilock.env`
* Systemd units for `digilock-config-apply`, `digilock-hw-agent`,
  `digilock-kiosk`, and `digilock-updater.timer`
* Initial API contract in `contracts/hw-bridge-openapi.yaml`

## Central Management Direction

Start with pull-based updates:

* Device keeps running current app offline
* Control plane publishes signed app bundles + policy
* Device agent pulls updates, verifies signature, swaps symlink atomically
* Rollback on health check failure

See `PLATFORM_PLAN.md` for implementation phases.