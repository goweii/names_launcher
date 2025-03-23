import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class IosRenameCommand extends RenameCommand {
  final String _iosRunnerPath = path.join('ios', 'Runner');
  final String _iosInfoPlistPath = path.join('ios', 'Runner', 'Info.plist');

  @override
  String get platformKey => YAML_PLATFORM_IOS_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    await _deleteOldAppNameFromInfoPlist();
    await _insertNewAppNameToInfoPlist(defaultName, localizedNames);
    await _insertBundleNameToInfoPlist(defaultName);
  }

  Future<void> _deleteOldAppNameFromInfoPlist() async {
    final runnerDir = Directory(_iosRunnerPath);
    if (!await runnerDir.exists()) {
      return;
    }
    runnerDir.listSync().forEach((entity) {
      if (entity.path.endsWith('.lproj')) {
        final lprojDir = Directory(entity.path);
        final stringsFile = File(path.join(lprojDir.path, 'InfoPlist.strings'));
        if (stringsFile.existsSync()) {
          final lines = stringsFile.readAsLinesSync();
          lines.removeWhere((line) => line.contains('CFBundleName'));
          lines.removeWhere((line) => line.contains('CFBundleDisplayName'));
          if (lines.isEmpty) {
            stringsFile.deleteSync();
          } else {
            stringsFile.writeAsStringSync(lines.join('\n'));
          }

          if (lprojDir.listSync().isEmpty) {
            lprojDir.deleteSync();
          }
        }
      }
    });
  }

  Future<void> _insertNewAppNameToInfoPlist(
    String defaultName,
    Map<String, String>? localizedNames,
  ) async {
    final runnerDir = Directory(_iosRunnerPath);

    Future<void> insertAppNameToDir(String lprojDir, String appName) async {
      final stringsFile = File(path.join(lprojDir, 'InfoPlist.strings'));
      if (!await stringsFile.exists()) {
        await stringsFile.create(recursive: true);
      }
      List<String> lines = await stringsFile.readAsLines();
      lines.removeWhere((e) => e.contains('CFBundleName = '));
      lines.removeWhere((e) => e.contains('CFBundleDisplayName = '));
      lines.insert(0, 'CFBundleDisplayName = "$appName";');
      lines.insert(0, 'CFBundleName = "$appName";');
      await stringsFile.writeAsString(lines.join('\n'));
    }

    await insertAppNameToDir(
        path.join(runnerDir.path, 'Base.lproj'), defaultName);

    if (localizedNames == null) {
      return;
    }

    for (var element in localizedNames.entries) {
      final localeName = element.key;
      final appName = element.value;
      final lprojDir = path.join(runnerDir.path, '$localeName.lproj');
      await insertAppNameToDir(lprojDir, appName);
    }
  }

  Future<void> _insertBundleNameToInfoPlist(String defaultName) async {
    final file = await File(_iosInfoPlistPath);
    final lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('<key>CFBundleName</key>')) {
        final prefix = lines[i].substring(0, lines[i].indexOf('<'));
        lines[i + 1] = '${prefix}<string>$defaultName</string>\r';
        break;
      }
    }

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('<key>CFBundleDisplayName</key>')) {
        final prefix = lines[i].substring(0, lines[i].indexOf('<'));
        lines[i + 1] = '${prefix}<string>$defaultName</string>\r';
        break;
      }
    }

    await file.writeAsString(lines.join('\n'));
  }
}
