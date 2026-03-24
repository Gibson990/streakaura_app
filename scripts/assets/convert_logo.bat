@echo off
REM Convert app logo SVG to PNG at various sizes for Android and iOS
REM Requires: ImageMagick (install from https://imagemagick.org/script/download.php)

set SCRIPT_DIR=%~dp0
set SVG_FILE=%SCRIPT_DIR%..\..\assets\svg\app_logo.svg
set OUTPUT_DIR=%SCRIPT_DIR%..\..\assets\images

REM Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Prefer `magick`, fallback to legacy `convert`
where magick >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set IM_CMD=magick
) else (
    where convert >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set IM_CMD=convert
    ) else (
        echo Error: ImageMagick not found!
        echo Install from: https://imagemagick.org/script/download.php and ensure either 'magick.exe' or 'convert.exe' is on your PATH.
        exit /b 1
    )
)

echo Using ImageMagick via %IM_CMD%...

%IM_CMD% "%SVG_FILE%" -background none -resize 48x48 "%OUTPUT_DIR%\ic_launcher_48.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 72x72 "%OUTPUT_DIR%\ic_launcher_72.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 96x96 "%OUTPUT_DIR%\ic_launcher_96.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 144x144 "%OUTPUT_DIR%\ic_launcher_144.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 192x192 "%OUTPUT_DIR%\ic_launcher_192.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 512x512 "%OUTPUT_DIR%\ic_launcher_512.png"

echo Logo PNGs created in %OUTPUT_DIR%
echo Copy to:
echo   - android\app\src\main\res\mipmap-mdpi\ic_launcher.png (48x48)
echo   - android\app\src\main\res\mipmap-hdpi\ic_launcher.png (72x72)
echo   - android\app\src\main\res\mipmap-xhdpi\ic_launcher.png (96x96)
echo   - android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png (144x144)
echo   - android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png (192x192)
echo   - Play Store: 512x512

