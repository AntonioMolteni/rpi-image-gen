#!/bin/sh
set -eu

SRC_SVG="${1:-examples/digilock/digilock_white.svg}"
OUT_TGA="${2:-examples/digilock/digilock-splash.tga}"
TMP_PNG="${OUT_TGA%.tga}.png"

# Full-HD splash for sharper output on 1080p displays.
CANVAS_W=1920
CANVAS_H=1080

# Slightly smaller logo target box than before.
LOGO_BOX_W=1350
LOGO_BOX_H=700

if [ ! -f "$SRC_SVG" ]; then
  echo "Error: SVG not found: $SRC_SVG" >&2
  exit 1
fi

if command -v rsvg-convert >/dev/null 2>&1; then
  # Set width only to preserve source aspect ratio during SVG rasterization.
  rsvg-convert -w "$((CANVAS_W * 2))" "$SRC_SVG" -o "$TMP_PNG"
elif command -v inkscape >/dev/null 2>&1; then
  # Set width only to preserve source aspect ratio during SVG rasterization.
  inkscape "$SRC_SVG" --export-type=png --export-width="$((CANVAS_W * 2))" --export-filename="$TMP_PNG" >/dev/null
elif command -v convert >/dev/null 2>&1; then
  convert "$SRC_SVG" "$TMP_PNG"
else
  echo "Error: need one of rsvg-convert, inkscape, or convert to render SVG" >&2
  exit 1
fi

if command -v convert >/dev/null 2>&1; then
  # Letterbox onto a pure black canvas while preserving logo aspect ratio.
  convert "$TMP_PNG" \
    -trim +repage \
    -filter Lanczos \
    -resize "${LOGO_BOX_W}x${LOGO_BOX_H}" \
    -background '#000000' \
    -gravity center \
    -extent "${CANVAS_W}x${CANVAS_H}" \
    -alpha off \
    -type TrueColor \
    -depth 8 \
    TGA:"$OUT_TGA"

  # Optional sanity printout (e.g. '24-bit TrueColor').
  identify -quiet -format 'Generated splash: %z-bit %r\n' "$OUT_TGA" || true
  rm -f "$TMP_PNG"
  echo "Generated $OUT_TGA"
else
  echo "Error: convert is required for final TGA output" >&2
  exit 1
fi