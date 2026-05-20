import 'package:flutter/foundation.dart';

import '../models/app_user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service;

  AuthService? _service;
  AuthService get service => _service ??= AuthService();
  AppUserModel? user;
  bool isLoading = false;
  String? error;

  bool get isLoggedIn => user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  Future<void> loadCurrentUser() async {
    isLoading = true;
    notifyListeners();
    try { user = await service.getCurrentUserProfile(); error = null; } catch (e) { error = e.toString(); } finally { isLoading = false; notifyListeners(); }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try { user = await service.login(email, password); error = null; return true; } catch (e) { error = e.toString(); return false; } finally { isLoading = false; notifyListeners(); }
  }

  Future<bool> register({required String fullName, required String email, required String phone, required String password}) async {
    isLoading = true;
    notifyListeners();
    try { user = await service.register(fullName: fullName, email: email, phone: phone, password: password); error = null; return true; } catch (e) { error = e.toString(); return false; } finally { isLoading = false; notifyListeners(); }
  }

  Future<void> logout() async { await service.logout(); user = null; notifyListeners(); }
}


