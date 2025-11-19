import 'package:a4tech_webui/services/system_service.dart';
import 'package:flutter/material.dart';

enum ServiceStatus { running, stopped, loading, error }

class SystemProvider with ChangeNotifier {
  final SystemService _systemService = SystemService();

  ServiceStatus _status = ServiceStatus.loading;
  ServiceStatus get status => _status;

  String? _error;
  String? get error => _error;

  SystemProvider() {
    checkServiceStatus();
  }

  Future<void> checkServiceStatus() async {
    _status = ServiceStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final isRunning = await _systemService.isOllamaServiceRunning();
      _status = isRunning ? ServiceStatus.running : ServiceStatus.stopped;
    } catch (e) {
      _error = e.toString();
      _status = ServiceStatus.error;
    }
    notifyListeners();
  }

  Future<void> startService() async {
    _status = ServiceStatus.loading;
    notifyListeners();
    try {
      await _systemService.startOllamaService();
      await checkServiceStatus();
    } catch (e) {
      _error = e.toString();
      _status = ServiceStatus.error;
    }
    notifyListeners();
  }

  Future<void> stopService() async {
    _status = ServiceStatus.loading;
    notifyListeners();
    try {
      await _systemService.stopOllamaService();
      await checkServiceStatus();
    } catch (e) {
      _error = e.toString();
      _status = ServiceStatus.error;
    }
    notifyListeners();
  }
}
