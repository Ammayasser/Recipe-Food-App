import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumProvider with ChangeNotifier {
  bool _isPremium = false;
  static const String _premiumKey = 'is_premium_user';

  PremiumProvider() {
    _loadPremiumStatus();
  }

  bool get isPremium => _isPremium;

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;
    notifyListeners();
  }

  Future<void> setPremiumStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, status);
    _isPremium = status;
    notifyListeners();
  }

  // Premium feature checks
  bool get hasAdvancedMealPlanning => _isPremium;
  bool get hasChefConsultations => _isPremium;
  bool get hasExclusiveRecipes => _isPremium;
  bool get isAdFree => _isPremium;
  bool get hasPrioritySupport => _isPremium;
}
