import 'package:flutter/foundation.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({NotificationService? service}) : _service = service;

  NotificationService? _service;
  NotificationService get service => _service ??= NotificationService();
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String? error;

  Future<void> loadNotifications(String userId) async { isLoading = true; notifyListeners(); try { notifications = await service.getNotifications(userId); error = null; } catch (e) { error = e.toString(); } finally { isLoading = false; notifyListeners(); } }
}


