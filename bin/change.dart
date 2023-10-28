import 'package:args/args.dart';
import 'package:names_launcher/cli_commands.dart';
import 'package:names_launcher/constants.dart';

/// Run to change launcher names
void main(List<String> arguments) async {
  print(START_MESSAGE);

  final parser = ArgParser();

  parser.addOption('path');

  final parsedArgs = parser.parse(arguments);

  await changeLauncherNames(path: parsedArgs['path']);

  print(END_MESSAGE);
}
