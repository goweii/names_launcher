import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class LinuxRenameCommand extends RenameCommand {
  final _linuxCMakeListsPath = path.join('linux', 'CMakeLists.txt');

  @override
  String get platformKey => YAML_PLATFORM_LINUX_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    final file = File(_linuxCMakeListsPath);
    final lines = await file.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('set(BINARY_NAME')) {
        lines[i] = 'set(BINARY_NAME \"${defaultName}\")';
        break;
      }
    }
    await file.writeAsString(lines.join('\n'));
  }
}
