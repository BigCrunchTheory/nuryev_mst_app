import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../services/storage_service.dart';

class AppViewModel extends ChangeNotifier {
  final StorageService _storageService;

  AppViewModel(this._storageService);

  SubscriptionModel? _subscription;
  bool _isLoading = false;

  SubscriptionModel? get subscription => _subscription;
  bool get isLoading => _isLoading;
  bool get hasSubscription => _subscription != null;

  /// Initialize app state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _subscription = await _storageService.getSubscription();

    _isLoading = false;
    notifyListeners();
  }

  /// Set subscription after purchase
  Future<void> setSubscription(String plan) async {
    _isLoading = true;
    notifyListeners();

    await _storageService.saveSubscription(plan);
    _subscription = await _storageService.getSubscription();

    _isLoading = false;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.clearSubscription();
    _subscription = null;

    _isLoading = false;
    notifyListeners();
  }
}
