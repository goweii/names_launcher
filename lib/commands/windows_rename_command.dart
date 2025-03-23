import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class WindowsRenameCommand extends RenameCommand {
  final _windowsAppPath = path.join('windows', 'runner', 'main.cpp');

  @override
  String get platformKey => YAML_PLATFORM_WINDOWS_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    final file = File(_windowsAppPath);
    final lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('window.CreateAndShow')) {
        final regExp = RegExp(r'CreateAndShow\(L"(.*?)"');
        var match = regExp.firstMatch(lines[i]);
        final currentAppName = match?.group(1)?.trim();
        if (currentAppName != null) {
          lines[i] = lines[i].replaceFirst(currentAppName, defaultName);
        }
        break;
      } else if (lines[i].contains('window.Create')) {
        final regExp = RegExp(r'Create\(L"(.*?)"');
        var match = regExp.firstMatch(lines[i]);
        final currentAppName = match?.group(1)?.trim();
        if (currentAppName != null) {
          lines[i] = lines[i].replaceFirst(currentAppName, defaultName);
        }
        break;
      }
    }

    await file.writeAsString(lines.join('\n'));
  }
}
