import 'package:names_launcher/version.dart';

/// Start message for the CLI
const String START_MESSAGE = '''\n
╔════════════════════════════════════════════════════╗
║             ✨✨  NAMES LAUNCHER  ✨✨             ║
╠════════════════════════════════════════════════════╣
║                   Version: $packageVersion                   ║
╚════════════════════════════════════════════════════╝
\n''';

/// End message for the CLI
const String END_MESSAGE = '''\n
==> CHANGE LAUNCHER NAMES SUCCESSFULLY <==
            ❤️   THANK YOU! ❤️
''';

const String YAML_ROOT_KEY = 'names_launcher';
const String YAML_NAME_KEY = 'name';
const String YAML_PLATFORMS_KEY = 'platforms';
const String YAML_ENABLE_KEY = 'enable';
const String YAML_PLATFORM_ANDROID_KEY = 'android';
const String YAML_PLATFORM_IOS_KEY = 'ios';
const String YAML_PLATFORM_MACOS_KEY = 'macos';
const String YAML_PLATFORM_WINDOWS_KEY = 'windows';
const String YAML_PLATFORM_LINUX_KEY = 'linux';
const String YAML_PLATFORM_WEB_KEY = 'web';
