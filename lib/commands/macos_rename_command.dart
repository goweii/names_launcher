import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class MacosRenameCommand extends RenameCommand {
  final _macosAppInfoxprojPath =
      path.join('macos', 'Runner', 'Configs', 'AppInfo.xcconfig');

  @override
  String get platformKey => YAML_PLATFORM_MACOS_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    final file = File(_macosAppInfoxprojPath);
    List? lines = await file.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('PRODUCT_NAME')) {
        lines[i] = 'PRODUCT_NAME = $defaultName';
        break;
      }
    }
    await file.writeAsString(lines.join('\n'));
  }
}
