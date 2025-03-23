abstract class RenameCommand {
  String get platformKey;

  Future<void> rename(
    String defaultName, [
    Map<String, String>? localizedNames,
  ]);
}
