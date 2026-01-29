import 'dart:io' as io;

const bool platformIsWeb = false;

bool get platformIsIOS => io.Platform.isIOS;
bool get platformIsAndroid => io.Platform.isAndroid;
bool get platformIsMacOS => io.Platform.isMacOS;
bool get platformIsWindows => io.Platform.isWindows;
bool get platformIsLinux => io.Platform.isLinux;

String get platformOperatingSystem => io.Platform.operatingSystem;
