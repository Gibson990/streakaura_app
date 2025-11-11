#!/bin/bash

# Convert splash logo SVG to PNG for splash screen
# Requires: ImageMagick or Inkscape

SVG_FILE="../assets/splash/splash_logo.svg"
OUTPUT_DIR="../assets/images"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check for ImageMagick
if command -v convert &> /dev/null; then
    echo "Using ImageMagick..."
    
    # Splash screen sizes
    convert -background none "$SVG_FILE" -resize 1024x1024 "$OUTPUT_DIR/splash_logo_1024.png"
    convert -background none "$SVG_FILE" -resize 2048x2048 "$OUTPUT_DIR/splash_logo_2048.png"
    
    echo "✓ Splash PNGs created in $OUTPUT_DIR"
    echo "Use for flutter_native_splash configuration"
    
# Check for Inkscape
elif command -v inkscape &> /dev/null; then
    echo "Using Inkscape..."
    
    inkscape --export-type=png --export-width=1024 --export-filename="$OUTPUT_DIR/splash_logo_1024.png" "$SVG_FILE"
    inkscape --export-type=png --export-width=2048 --export-filename="$OUTPUT_DIR/splash_logo_2048.png" "$SVG_FILE"
    
    echo "✓ Splash PNGs created in $OUTPUT_DIR"
else
    echo "❌ Error: ImageMagick or Inkscape not found!"
    exit 1
fi

