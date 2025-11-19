import 'dart:async';
import 'package:flutter/material.dart';
import '../api/ollama_api_service.dart';
import '../models/model_model.dart';

class ModelProvider with ChangeNotifier {
  final OllamaApiService _apiService = OllamaApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OllamaModel> _models = [];
  List<OllamaModel> get models => _models;

  String? _error;
  String? get error => _error;

  String _downloadStatus = '';
  String get downloadStatus => _downloadStatus;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  ModelProvider() {
    fetchModels();
  }

  Future<void> fetchModels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final modelsJson = await _apiService.getLocalModels();
      _models = modelsJson.map((json) => OllamaModel.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pullModel(String modelName) async {
    _isDownloading = true;
    _downloadStatus = 'Starting download for $modelName...';
    _error = null;
    notifyListeners();

    try {
      final stream = _apiService.pullModel(modelName);
      await for (var status in stream) {
        _downloadStatus = status;
        notifyListeners();
      }
      await fetchModels(); // Refresh the list after download
    } catch (e) {
      _error = e.toString();
    } finally {
      _isDownloading = false;
      _downloadStatus = '';
      notifyListeners();
    }
  }

  Future<void> deleteModel(String modelName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteModel(modelName);
      await fetchModels(); // Refresh the list after deletion
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}