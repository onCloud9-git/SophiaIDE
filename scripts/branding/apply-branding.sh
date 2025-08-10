#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
LOGO_PNG="${1:-$ROOT/branding/logo.png}"
if [[ ! -f "$LOGO_PNG" ]]; then
  echo "Logo not found: $LOGO_PNG" >&2; exit 1;
fi
# Ensure target dirs
mkdir -p "$ROOT/resources/darwin" "$ROOT/resources/win32" "$ROOT/resources/linux" "$ROOT/resources/server"

# 1) macOS ICNS
ICONSET_DIR=$(mktemp -d "$ROOT/scripts/branding/iconset.XXXXXX").iconset
mkdir -p "$ICONSET_DIR"
for sz in 16 32 64 128 256 512; do
  sips -s format png "$LOGO_PNG" --resampleWidth $sz   --out "$ICONSET_DIR/icon_${sz}x${sz}.png" >/dev/null
  sips -s format png "$LOGO_PNG" --resampleWidth $((sz*2)) --out "$ICONSET_DIR/icon_${sz}x${sz}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET_DIR" -o "$ROOT/resources/darwin/code.icns"
cp -f "$ROOT/resources/darwin/code.icns" "$ROOT/resources/darwin/code_file.icns" || true
rm -rf "$ICONSET_DIR"

echo "macOS icns generated"

# 2) Windows ICO (requires ImageMagick 'magick' or 'convert')
WIN_TMP=$(mktemp -d "$ROOT/scripts/branding/win.XXXXXX")
for sz in 16 24 32 48 64 128 256; do
  sips -s format png "$LOGO_PNG" --resampleWidth $sz --out "$WIN_TMP/${sz}.png" >/dev/null
done
if command -v magick >/dev/null 2>&1; then
  magick "$WIN_TMP/16.png" "$WIN_TMP/24.png" "$WIN_TMP/32.png" "$WIN_TMP/48.png" "$WIN_TMP/64.png" "$WIN_TMP/128.png" "$WIN_TMP/256.png" "$ROOT/resources/win32/code.ico"
  cp -f "$ROOT/resources/win32/code.ico" "$ROOT/resources/win32/code_file.ico" || true
  cp -f "$ROOT/resources/win32/code.ico" "$ROOT/resources/win32/setup.ico" || true
elif command -v convert >/dev/null 2>&1; then
  convert "$WIN_TMP/16.png" "$WIN_TMP/24.png" "$WIN_TMP/32.png" "$WIN_TMP/48.png" "$WIN_TMP/64.png" "$WIN_TMP/128.png" "$WIN_TMP/256.png" "$ROOT/resources/win32/code.ico"
  cp -f "$ROOT/resources/win32/code.ico" "$ROOT/resources/win32/code_file.ico" || true
  cp -f "$ROOT/resources/win32/code.ico" "$ROOT/resources/win32/setup.ico" || true
else
  echo "ImageMagick not found. Skipping Windows .ico regeneration. Install with: brew install imagemagick" >&2
fi
rm -rf "$WIN_TMP"

echo "Windows icons handled"

# 3) Linux PNG (replace main code.png with 512)
LINUX_512="$ROOT/resources/linux/code.png"
sips -s format png "$LOGO_PNG" --resampleWidth 512 --out "$LINUX_512" >/dev/null || true

echo "Linux icon updated"

# 4) Web favicon (requires ImageMagick)
if command -v magick >/dev/null 2>&1; then
  magick "$LOGO_PNG" -resize 256x256 -define icon:auto-resize=16,32,48,64,128,256 "$ROOT/resources/server/favicon.ico"
elif command -v convert >/dev/null 2>&1; then
  convert "$LOGO_PNG" -resize 256x256 -colors 256 "$ROOT/resources/server/favicon.ico"
else
  echo "ImageMagick not found. Skipping favicon regeneration." >&2
fi

echo "Web favicon handled"

echo "Branding applied from $LOGO_PNG"
