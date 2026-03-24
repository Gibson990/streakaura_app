@echo off
REM Convert splash logo SVG to PNG for splash screen
REM Requires: ImageMagick

set SCRIPT_DIR=%~dp0
set SVG_FILE=%SCRIPT_DIR%..\..\assets\splash\splash_logo.svg
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

%IM_CMD% "%SVG_FILE%" -background none -resize 1024x1024 "%OUTPUT_DIR%\splash_logo_1024.png"
%IM_CMD% "%SVG_FILE%" -background none -resize 2048x2048 "%OUTPUT_DIR%\splash_logo_2048.png"

echo Splash PNGs created in %OUTPUT_DIR%
echo Use for flutter_native_splash configuration

