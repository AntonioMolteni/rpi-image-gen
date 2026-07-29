This directory contains the Jellyfin apt repository public key used by the example.

Expected file path:
./examples/digilock-webkiosk/keyrings/digilock-kiosk-archive-keyring.asc

If you switch to a different apt repository:
1. Export that repository public key in ASCII armored format.
2. Replace this file content with the new key.
3. Keep the BEGIN/END PGP PUBLIC KEY BLOCK lines.

Why this exists:
- The image build copies this key into /etc/apt/keyrings.
- apt uses this key to verify repository metadata signatures.
