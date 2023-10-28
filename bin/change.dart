import 'package:args/args.dart';
import 'package:names_launcher/cli_commands.dart';
import 'package:names_launcher/constants.dart';

/// Run to change launcher names
void main(List<String> arguments) {
  print(START_MESSAGE);

  final parser = ArgParser();

  parser.addOption('path');

  final parsedArgs = parser.parse(arguments);

  changeLauncherNames(path: parsedArgs['path']);

  print(END_MESSAGE);
}
