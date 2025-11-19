import 'dart:io';

class SystemService {
  Future<bool> isOllamaServiceRunning() async {
    if (Platform.isLinux) {
      final result = await Process.run('systemctl', ['is-active', 'ollama']);
      return result.stdout.toString().trim() == 'active';
    }
    // TODO: Implement for other platforms
    return false;
  }

  Future<ProcessResult> startOllamaService() async {
    if (Platform.isLinux) {
      // Note: This may require sudo privileges, which is complex to handle from a Flutter app.
      // This is a simplified example.
      return await Process.run('systemctl', ['start', 'ollama']);
    }
    throw UnimplementedError('Service management not implemented for this platform.');
  }

  Future<ProcessResult> stopOllamaService() async {
    if (Platform.isLinux) {
      return await Process.run('systemctl', ['stop', 'ollama']);
    }
    throw UnimplementedError('Service management not implemented for this platform.');
  }
}
