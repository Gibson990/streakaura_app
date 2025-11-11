@echo off
REM Convert splash logo SVG to PNG for splash screen
REM Requires: ImageMagick

set SVG_FILE=..\assets\splash\splash_logo.svg
set OUTPUT_DIR=..\assets\images

REM Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Check for ImageMagick
where convert >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using ImageMagick...
    
    convert -background none "%SVG_FILE%" -resize 1024x1024 "%OUTPUT_DIR%\splash_logo_1024.png"
    convert -background none "%SVG_FILE%" -resize 2048x2048 "%OUTPUT_DIR%\splash_logo_2048.png"
    
    echo Splash PNGs created in %OUTPUT_DIR%
    echo Use for flutter_native_splash configuration
) else (
    echo Error: ImageMagick not found!
    echo Install from: https://imagemagick.org/script/download.php
    exit /b 1
)

