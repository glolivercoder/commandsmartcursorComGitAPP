import 'package:flutter/material.dart';
import '../services/database_service.dart';

class GitHubAccountProvider with ChangeNotifier {
  List<Map<String, dynamic>> _accounts = [];
  String? _error;
  bool _isLoading = false;

  List<Map<String, dynamic>> get accounts => _accounts;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadAccounts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _accounts = await DatabaseService.getGitHubAccounts();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAccount(String username, String token) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await DatabaseService.addGitHubAccount(username, token);
      await loadAccounts(); // Recarrega a lista após adicionar
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAccount(String username) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await DatabaseService.deleteGitHubAccount(username);
      await loadAccounts(); // Recarrega a lista após deletar
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}