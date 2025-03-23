import 'dart:io';

import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:path/path.dart' as path;

class WebRenameCommand extends RenameCommand {
  final _webIndexPath = path.join('web', 'index.html');

  @override
  String get platformKey => YAML_PLATFORM_WEB_KEY;

  @override
  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]) async {
    final file = File(_webIndexPath);
    final lines = await file.readAsLines();

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains('<title>') && lines[i].contains('</title>')) {
        lines[i] = '  <title>$defaultName</title>';
        break;
      }
    }

    await file.writeAsString(lines.join('\n'));
  }
}
