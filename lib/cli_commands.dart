library names_launcher;

import 'dart:io';

import 'package:names_launcher/commands/android_rename_command.dart';
import 'package:names_launcher/commands/ios_rename_command.dart';
import 'package:names_launcher/commands/linux_rename_command.dart';
import 'package:names_launcher/commands/macos_rename_command.dart';
import 'package:names_launcher/commands/rename_command.dart';
import 'package:names_launcher/commands/web_rename_command.dart';
import 'package:names_launcher/commands/windows_rename_command.dart';
import 'package:names_launcher/constants.dart';
import 'package:yaml/yaml.dart';

Future<void> changeLauncherNames({
  required String? path,
}) async {
  final File yamlFile = File(path ?? 'pubspec.yaml');
  final Map yamlData = loadYaml(yamlFile.readAsStringSync());
  final Map? yamlRoot = yamlData[YAML_ROOT_KEY];

  if (yamlRoot == null) {
    throw Exception(
        'Error: missing key; your yaml file must contain the ${YAML_ROOT_KEY} key.');
  }

  final Map? yamlPlatforms = yamlRoot[YAML_PLATFORMS_KEY];

  if (yamlPlatforms == null) {
    throw Exception(
        'Error: missing key; your yaml file must contain the ${YAML_PLATFORMS_KEY} key.');
  }

  final renameCommands = [
    AndroidRenameCommand(),
    IosRenameCommand(),
    MacosRenameCommand(),
    WindowsRenameCommand(),
    LinuxRenameCommand(),
    WebRenameCommand(),
  ];

  final defaultName = _getDefaultName(yamlRoot);

  if (defaultName == null || defaultName.isEmpty) {
    throw Exception(
        'Error: missing key; your yaml file must contain the ${YAML_NAME_KEY} key.');
  }

  final localizedNames = _getLocalizedNames(yamlRoot);

  renameCommands.forEach((command) async {
    final yamlPlatform = yamlPlatforms[command.platformKey];

    if (_isPlatformEnabled(yamlPlatform, false)) {
      var currentDefaultName = _getDefaultName(yamlPlatform);
      if (currentDefaultName == null || currentDefaultName.isEmpty) {
        currentDefaultName = defaultName;
      }

      final currentLocalizedNames = <String, String>{};
      if (localizedNames != null) {
        currentLocalizedNames.addAll(localizedNames);
      }
      final thisLocalizedNames = _getLocalizedNames(yamlPlatform);
      if (thisLocalizedNames != null) {
        currentLocalizedNames.addAll(thisLocalizedNames);
      }

      await _changeLauncherName(
        command: command,
        defaultName: currentDefaultName,
        localizedNames: currentLocalizedNames,
      );
    }
  });
}

Future<void> _changeLauncherName({
  required RenameCommand command,
  String? defaultName,
  Map<String, String>? localizedNames,
}) async {
  final platform = command.platformKey;
  if (defaultName == null) {
    print(
        'Change $platform launcher name failed. Did you forget to configure name in yaml?');
    return;
  }
  if (defaultName.isEmpty) {
    print(
        'Change $platform launcher name failed. The name should not be empty.');
    return;
  }
  print('Change $platform launcher name to "$defaultName".');
  await command.rename(defaultName, localizedNames);
  print('Change $platform launcher name successfully.');
}

bool _isPlatformEnabled(Map? yamlPlatform, bool defaultValue) {
  final value = yamlPlatform?[YAML_ENABLE_KEY];
  if (value == null) {
    return defaultValue;
  }
  return bool.parse(value.toString());
}

String? _getDefaultName(Map? yaml) {
  if (yaml == null) {
    return null;
  }
  final value = yaml[YAML_NAME_KEY];
  if (value == null) {
    return null;
  }
  final String? name;
  if (value is! Map) {
    name = value.toString();
  } else {
    name = value[YAML_DEFAULT_KEY]?.toString();
  }
  return name;
}

Map<String, String>? _getLocalizedNames(Map? yaml) {
  if (yaml == null) {
    return null;
  }
  final value = yaml[YAML_NAME_KEY];
  if (value == null) {
    return null;
  }
  if (value is! Map) {
    return null;
  }
  final Map<String, String> names = {};
  value.entries.forEach((entry) {
    final key = entry.key.toString();
    if (key != YAML_DEFAULT_KEY) {
      final value = entry.value.toString();
      names[key] = value;
    }
  });
  return names;
}
