import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class AndroidRenameCommand extends RenameCommand {
  final String _androidResPath =
      path.join('android', 'app', 'src', 'main', 'res');
  final String _androidManifestPath =
      path.join('android', 'app', 'src', 'main', 'AndroidManifest.xml');

  @override
  String get platformKey => YAML_PLATFORM_ANDROID_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    await _removeOldAppNameFromRes();
    await _insertNewAppNameToRes(defaultName, localizedNames);
    await _insertLabelToManifest();
  }

  Future<void> _removeOldAppNameFromRes() async {
    final resDir = Directory(_androidResPath);
    if (!await resDir.exists()) {
      return;
    }
    final valueDirs = resDir.listSync().where((e) {
      if (e is! Directory) return false;
      final basename = path.basename(e.path);
      return basename == 'values' || basename.startsWith('values');
    });

    for (var dir in valueDirs) {
      final stringsFile = File(path.join(dir.path, 'strings.xml'));
      if (await stringsFile.exists()) {
        List<String> lines = await stringsFile.readAsLines();
        lines.removeWhere((line) => line.contains('<string name="app_name">'));
        if (lines.where((line) => line.contains('<string ')).isEmpty) {
          await stringsFile.delete();
        } else {
          await stringsFile.writeAsString(lines.join('\n'));
        }
      }

      if (Directory(dir.path).listSync().isEmpty) {
        await dir.delete();
      }
    }
  }

  Future<void> _insertNewAppNameToRes(
    String defaultName,
    Map<String, String>? localizedNames,
  ) async {
    final resDir = Directory(_androidResPath);

    Future<void> insertAppNameToDir(String valuesDir, String appName) async {
      final stringsFile = File(path.join(valuesDir, 'strings.xml'));
      if (!await stringsFile.exists()) {
        await stringsFile.create(recursive: true);
        await stringsFile
            .writeAsString('''<?xml version="1.0" encoding="utf-8"?>
<resources>
</resources>
''');
      }

      final lines = await stringsFile.readAsLines();
      lines.removeWhere((e) => e.contains('<string name="app_name">'));
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('<resources>')) {
          lines.insert(i + 1, '    <string name="app_name">$appName</string>');
          break;
        }
      }
      await stringsFile.writeAsString(lines.join('\n'));
    }

    await insertAppNameToDir(path.join(resDir.path, 'values'), defaultName);

    if (localizedNames == null) {
      return;
    }

    for (var element in localizedNames.entries) {
      final localeName = element.key;
      final appName = element.value;
      final valuesDir = path.join(resDir.path, 'values-$localeName');
      await insertAppNameToDir(valuesDir, appName);
    }
  }

  Future<void> _insertLabelToManifest() async {
    final file = await File(_androidManifestPath);
    final lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('android:label=')) {
        final line = lines[i];
        lines[i] = line.replaceFirst(RegExp(r'android:label="(.*?)"'),
            'android:label="@string/app_name"');
        break;
      }
    }

    await file.writeAsString(lines.join('\n'));
  }
}
