// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

class FileRepository {
  late Logger logger;
  String androidManifestPath =
      '.\\android\\app\\src\\main\\AndroidManifest.xml';
  String iosInfoPlistPath = '.\\ios\\Runner\\Info.plist';
  String androidAppBuildGradlePath = '.\\android\\app\\build.gradle';
  String iosProjectPbxprojPath = '.\\ios\\Runner.xcodeproj\\project.pbxproj';
  String macosAppInfoxprojPath = '.\\macos\\Runner\\Configs\\AppInfo.xcconfig';
  String launcherIconPath = '.\\assets\\images\\launcherIcon.png';
  String linuxCMakeListsPath = '.\\linux\\CMakeLists.txt';
  String linuxAppCppPath = '.\\linux\\my_application.cc';
  String webAppPath = '.\\linux\\my_application.cc';
  String windowsAppPath = '.\\web\\index.html';

  FileRepository() {
    logger = Logger(filter: ProductionFilter());
    if (Platform.isMacOS || Platform.isLinux) {
      androidManifestPath = 'android/app/src/main/AndroidManifest.xml';
      iosInfoPlistPath = 'ios/Runner/Info.plist';
      androidAppBuildGradlePath = 'android/app/build.gradle';
      iosProjectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';
      macosAppInfoxprojPath = 'macos/Runner/Configs/AppInfo.xcconfig';
      launcherIconPath = 'assets/images/launcherIcon.png';
      linuxCMakeListsPath = 'linux/CMakeLists.txt';
      linuxAppCppPath = 'linux/my_application.cc';
      windowsAppPath = 'web/index.html';
    }
  }

  Future<List<String?>?> readFileAsLineByline(
      {required String filePath}) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      logger.w('''
      File  $fileAsString
      ''');
      return fileAsString.split('\n');
    } catch (e) {
      return null;
    }
  }

  Future<String?> readAllFile({required String filePath}) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      return fileAsString;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeFile({required String filePath, required String content}) {
    return File(filePath).writeAsString(content);
  }

  Future<String?> getIosBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: iosProjectPbxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Ios BundleId could not be changed because,
      The related file could not be found in that path:  $iosProjectPbxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        return (contentLineByLine[i] as String).split('=').last.trim();
      }
    }
  }

  Future<File?> changeIosBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: iosProjectPbxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Ios BundleId could not be changed because,
      The related file could not be found in that path:  $iosProjectPbxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        contentLineByLine[i] = '				PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      }
    }
    var writtenFile = await writeFile(
      filePath: iosProjectPbxprojPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('IOS BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getMacOsBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      macOS BundleId could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        return (contentLineByLine[i] as String).split('=').last.trim();
      }
    }
  }

  Future<File?> changeMacOsBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      macOS BundleId could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        contentLineByLine[i] = 'PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      }
    }
    var writtenFile = await writeFile(
      filePath: macosAppInfoxprojPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('MacOS BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getAndroidBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: androidAppBuildGradlePath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Android BundleId could not be changed because,
      The related file could not be found in that path:  $androidAppBuildGradlePath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        return (contentLineByLine[i] as String).split('"').elementAt(1).trim();
      }
    }
  }

  Future<File?> changeAndroidBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: androidAppBuildGradlePath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Android BundleId could not be changed because,
      The related file could not be found in that path:  $androidAppBuildGradlePath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        contentLineByLine[i] = '        applicationId \"$bundleId\"';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: androidAppBuildGradlePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Android bundleId changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getLinuxBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux BundleId could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('set(APPLICATION_ID')) {
        return (contentLineByLine[i] as String).split('"').elementAt(1).trim();
      }
    }
  }

  Future<File?> changeLinuxBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux BundleId could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('set(APPLICATION_ID')) {
        contentLineByLine[i] = 'set(APPLICATION_ID \"$bundleId\")';
      }
    }
    var writtenFile = await writeFile(
      filePath: linuxCMakeListsPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Linux BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<File?> changeIosAppName(String? appName) async {
    var _iosFile = await readAllFile(
      filePath: iosInfoPlistPath,
    );
    if (checkFile(_iosFile)) {
      logger.w('''
      Ios AppName could not be changed because,
      The related file could not be found in that path:  $iosInfoPlistPath
      ''');
      return null;
    }
    _iosFile = _iosFile!.replaceFirst(
        RegExp(r'<key>CFBundleName<\/key>\n.+<string>(.*?)<\/string>'),
        '<key>CFBundleName<\/key>\n	<string>$appName<\/string>');
    var writtenFile = await writeFile(
      filePath: iosInfoPlistPath,
      content: _iosFile,
    );
    logger.i('IOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File?> changeMacOsAppName(String? appName) async {
    var _macIosFile = await readAllFile(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFile(_macIosFile)) {
      logger.w('''
      macOS AppName could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    _macIosFile = _macIosFile!.replaceFirst(
        RegExp(r'PRODUCT_NAME =.(.*?);'), 'PRODUCT_NAME = $appName;');
    var writtenFile = await writeFile(
      filePath: macosAppInfoxprojPath,
      content: _macIosFile,
    );
    logger.i('MacOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File?> changeAndroidAppName(String? appName) async {
    var _androidFile = await readAllFile(
      filePath: androidManifestPath,
    );
    if (checkFile(_androidFile)) {
      logger.w('''
      Android AppName could not be changed because,
      The related file could not be found in that path:  $androidManifestPath
      ''');
      return null;
    }
    _androidFile = _androidFile!.replaceFirst(
        RegExp(r'android:label="(.*?)"'), 'android:label="$appName"');
    var writtenFile = await writeFile(
      filePath: androidManifestPath,
      content: _androidFile,
    );
    logger.i('Android appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<bool> changeLinuxCppName(String? appName, String oldAppName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxAppCppPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux AppName could not be changed because,
      The related file could not be found in that path:  $linuxAppCppPath
      ''');
      return false;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      contentLineByLine[i] =
          contentLineByLine[i].replaceAll(oldAppName, appName);
    }
    return true;
  }

  Future<File?> changeLinuxAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux AppName could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    String? oldAppName;
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].startsWith('set(BINARY_NAME')) {
        oldAppName = RegExp(r'set\(BINARY_NAME "(\w+)"\)')
            .firstMatch(contentLineByLine[i])
            ?.group(1);
        contentLineByLine[i] = 'set(BINARY_NAME \"$appName\")';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: linuxCMakeListsPath,
      content: contentLineByLine.join('\n'),
    );
    if (oldAppName != null) {
      if (await changeLinuxCppName(appName, oldAppName) == false) {
        return null;
      }
    }
    logger.i('Linux appname changed successfully to : $appName');
    return writtenFile;
  }

  // ignore: missing_return
  Future<String?> getCurrentIosAppName() async {
    var contentLineByLine = await (readFileAsLineByline(
      filePath: iosInfoPlistPath,
    ) as FutureOr<List<dynamic>>);
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('<key>CFBundleName</key>')) {
        return (contentLineByLine[i + 1] as String).trim().substring(5, 5);
      }
    }
  }

  // ignore: missing_return
  Future<String?> getCurrentAndroidAppName() async {
    var contentLineByLine = await (readFileAsLineByline(
      filePath: androidManifestPath,
    ) as FutureOr<List<dynamic>>);
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('android:label')) {
        return (contentLineByLine[i] as String).split('"')[1];
      }
    }
  }

  bool checkFileExists(List? fileContent) {
    return fileContent == null || fileContent.isEmpty;
  }

  bool checkFile(String? fileContent) {
    return fileContent == null || fileContent.isEmpty;
  }

  Future<String?> getWebAppName() async {}

  Future<File?> changeWebAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: windowsAppPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Windows Appname could not be changed because,
      The related file could not be found in that path:  $windowsAppPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('<title>') &&
          contentLineByLine[i].contains('</title>')) {
        contentLineByLine[i] = '  <title>$appName</title>';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: windowsAppPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Windows appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<String?> getWindowsAppName() async {}

  Future<String?> changeWindowsAppName(String? appName) async {}
}
