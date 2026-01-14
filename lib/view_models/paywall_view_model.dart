import 'package:flutter/material.dart';

class PaywallViewModel extends ChangeNotifier {
  String _selectedPlan = 'month';
  bool _isLoading = false;

  String get selectedPlan => _selectedPlan;
  bool get isLoading => _isLoading;

  void selectPlan(String plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  Future<void> purchase(Function onSuccess) async {
    _isLoading = true;
    notifyListeners();

    // Simulate purchase process
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    onSuccess(_selectedPlan);
  }
}
