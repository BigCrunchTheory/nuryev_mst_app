import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';

class StorageService {
  static const String _subscriptionKey = 'has_subscription';
  static const String _planKey = 'subscription_plan';
  static const String _startDateKey = 'subscription_date';

  /// Check if user has an active subscription
  Future<bool> hasSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  /// Get subscription details
  Future<SubscriptionModel?> getSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSubscription = prefs.getBool(_subscriptionKey) ?? false;

    if (!hasSubscription) return null;

    final plan = prefs.getString(_planKey) ?? 'month';
    final timestamp = prefs.getInt(_startDateKey) ?? 0;
    final startDate = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final endDate = _calculateEndDate(startDate, plan);

    return SubscriptionModel(
      plan: plan,
      startDate: startDate,
      endDate: endDate,
      isActive: true,
    );
  }

  /// Save subscription
  Future<void> saveSubscription(String plan) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    _calculateEndDate(now, plan);

    await prefs.setBool(_subscriptionKey, true);
    await prefs.setString(_planKey, plan);
    await prefs.setInt(_startDateKey, now.millisecondsSinceEpoch);
  }

  /// Clear subscription
  Future<void> clearSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionKey);
    await prefs.remove(_planKey);
    await prefs.remove(_startDateKey);
  }

  /// Calculate subscription end date
  DateTime _calculateEndDate(DateTime startDate, String plan) {
    if (plan == 'month') {
      return DateTime(startDate.year, startDate.month + 1, startDate.day);
    } else {
      return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
  }
}
