#!/bin/bash

# Convert app logo SVG to PNG at various sizes for Android and iOS
# Requires: ImageMagick or Inkscape

SVG_FILE="../assets/svg/app_logo.svg"
OUTPUT_DIR="../assets/images"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check for ImageMagick
if command -v convert &> /dev/null; then
    echo "Using ImageMagick..."
    
    # Android mipmap sizes
    convert -background none "$SVG_FILE" -resize 48x48 "$OUTPUT_DIR/ic_launcher_48.png"
    convert -background none "$SVG_FILE" -resize 72x72 "$OUTPUT_DIR/ic_launcher_72.png"
    convert -background none "$SVG_FILE" -resize 96x96 "$OUTPUT_DIR/ic_launcher_96.png"
    convert -background none "$SVG_FILE" -resize 144x144 "$OUTPUT_DIR/ic_launcher_144.png"
    convert -background none "$SVG_FILE" -resize 192x192 "$OUTPUT_DIR/ic_launcher_192.png"
    convert -background none "$SVG_FILE" -resize 512x512 "$OUTPUT_DIR/ic_launcher_512.png"
    
    echo "✓ Logo PNGs created in $OUTPUT_DIR"
    echo "Copy to:"
    echo "  - android/app/src/main/res/mipmap-mdpi/ic_launcher.png (48x48)"
    echo "  - android/app/src/main/res/mipmap-hdpi/ic_launcher.png (72x72)"
    echo "  - android/app/src/main/res/mipmap-xhdpi/ic_launcher.png (96x96)"
    echo "  - android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png (144x144)"
    echo "  - android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png (192x192)"
    echo "  - Play Store: 512x512"
    
# Check for Inkscape
elif command -v inkscape &> /dev/null; then
    echo "Using Inkscape..."
    
    inkscape --export-type=png --export-width=48 --export-filename="$OUTPUT_DIR/ic_launcher_48.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=72 --export-filename="$OUTPUT_DIR/ic_launcher_72.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=96 --export-filename="$OUTPUT_DIR/ic_launcher_96.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=144 --export-filename="$OUTPUT_DIR/ic_launcher_144.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=192 --export-filename="$OUTPUT_DIR/ic_launcher_192.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=512 --export-filename="$OUTPUT_DIR/ic_launcher_512.png" "$SVG_FILE"
    
    echo "✓ Logo PNGs created in $OUTPUT_DIR"
else
    echo "❌ Error: ImageMagick or Inkscape not found!"
    echo "Install ImageMagick: brew install imagemagick (macOS) or apt-get install imagemagick (Linux)"
    echo "Or install Inkscape: brew install inkscape (macOS) or apt-get install inkscape (Linux)"
    exit 1
fi

