# Asset Conversion Scripts

This folder contains scripts to convert SVG logos to PNG format for app icons and splash screens.

## Prerequisites

### Option 1: ImageMagick (Recommended)
- **macOS**: `brew install imagemagick`
- **Linux**: `sudo apt-get install imagemagick`
- **Windows**: Download from https://imagemagick.org/script/download.php

### Option 2: Inkscape (Alternative)
- **macOS**: `brew install inkscape`
- **Linux**: `sudo apt-get install inkscape`
- **Windows**: Download from https://inkscape.org/release/

## Usage

### Convert App Logo
```bash
# macOS/Linux
./convert_logo.sh

# Windows
convert_logo.bat
```

This creates PNG files at various sizes:
- 48x48 (mdpi)
- 72x72 (hdpi)
- 96x96 (xhdpi)
- 144x144 (xxhdpi)
- 192x192 (xxxhdpi)
- 512x512 (Play Store)

### Convert Splash Logo
```bash
# macOS/Linux
./convert_splash.sh

# Windows
convert_splash.bat
```

This creates:
- 1024x1024 (standard splash)
- 2048x2048 (high-res splash)

## Manual Steps After Conversion

1. **Android Icons**: Copy PNGs to respective mipmap folders:
   - `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
   - `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
   - `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
   - `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
   - `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

2. **iOS Icons**: Use Xcode or online tools to generate AppIcon.appiconset from 1024x1024 PNG

3. **Splash Screen**: Configure in `flutter_native_splash.yaml` and run `flutter pub run flutter_native_splash:create`

## Quality Notes

- SVG source files maintain vector quality
- PNG outputs are optimized for each platform
- For best results, use ImageMagick with high DPI settings
- Consider using `-density 300` flag for higher quality exports

