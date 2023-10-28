library names_launcher;

import 'dart:io';

import 'package:names_launcher/constants.dart';
import 'package:rename/rename.dart';
import 'package:yaml/yaml.dart';

Future<void> changeLauncherNames({
  required String? path,
}) async {
  final File yamlFile = File(path ?? 'pubspec.yaml');
  final Map yamlData = loadYaml(yamlFile.readAsStringSync());
  final Map? yamlRoot = yamlData[YAML_ROOT_KEY];

  if (yamlRoot == null) {
    throw Exception('Error: missing key; your yaml file must contain the ${YAML_ROOT_KEY} key.');
  }

  final Map? yamlPlatforms = yamlRoot[YAML_PLATFORMS_KEY];

  if (yamlPlatforms == null) {
    throw Exception('Error: missing key; your yaml file must contain the ${YAML_PLATFORMS_KEY} key.');
  }

  final String? defaultName = yamlRoot[YAML_NAME_KEY];

  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_ANDROID_KEY], true)) {
    await _changeLauncherName(
      Platform.android,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_ANDROID_KEY], defaultName),
    );
  }
  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_IOS_KEY], true)) {
    await _changeLauncherName(
      Platform.ios,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_IOS_KEY], defaultName),
    );
  }
  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_MACOS_KEY], false)) {
    await _changeLauncherName(
      Platform.macOS,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_MACOS_KEY], defaultName),
    );
  }
  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_WINDOWS_KEY], false)) {
    await _changeLauncherName(
      Platform.windows,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_WINDOWS_KEY], defaultName),
    );
  }
  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_LINUX_KEY], false)) {
    await _changeLauncherName(
      Platform.linux,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_LINUX_KEY], defaultName),
    );
  }
  if (_isPlatformEnabled(yamlPlatforms[YAML_PLATFORM_WEB_KEY], false)) {
    await _changeLauncherName(
      Platform.web,
      _getPlatformLauncherName(yamlPlatforms[YAML_PLATFORM_WEB_KEY], defaultName),
    );
  }
}

Future<void> _changeLauncherName(Platform platform, String? name) async {
  if (name == null) {
    print('Change $platform launcher name failed. Did you forget to configure name in yaml?');
    return;
  }
  if (name.isEmpty) {
    print('Change $platform launcher name failed. The name should not be empty.');
    return;
  }
  print('Change $platform launcher name to "$name".');
  await changeAppName(name, [platform]);
  print('Change $platform launcher name successfully.');
}

bool _isPlatformEnabled(Map yamlPlatform, bool defaultValue) {
  final value = yamlPlatform[YAML_ENABLE_KEY];
  if (value == null) {
    return defaultValue;
  }
  return bool.parse(value.toString());
}

String? _getPlatformLauncherName(Map yamlPlatform, String? defaultValue) {
  final String? name;
  final value = yamlPlatform[YAML_NAME_KEY];
  if (value == null) {
    name = defaultValue;
  } else {
    name = value.toString();
  }
  return name;
}
