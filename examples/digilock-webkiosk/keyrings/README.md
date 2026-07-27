Place your apt repository public key here.

Expected file path:
./examples/digilock-webkiosk/keyrings/digilock-kiosk-archive-keyring.asc

How to create this file:
1. Export your repository public key in ASCII armored format.
2. Replace the placeholder file content with that real key.
3. Keep the BEGIN/END PGP PUBLIC KEY BLOCK lines.

Why this exists:
- The image build copies this key into /etc/apt/keyrings.
- apt uses this key to verify repository metadata signatures.
