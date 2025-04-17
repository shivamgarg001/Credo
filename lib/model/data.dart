import 'package:flutter/material.dart';
import 'package:credo/pages/ledger.dart';
import 'package:credo/pages/settings.dart';
import 'package:credo/widgets/ledger/tab.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum SwitchType {
  appLock,
  paymentPassword,
  fingerPrint,
}

class DataModel with ChangeNotifier {
  final List<Widget> _navigationOptions = [
    const LedgerPage(),
    const SettingsPage(),
  ];

  List<Widget> get navigationOptions => _navigationOptions;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> _tabs = [
    const CustomTab(title: 'CUSTOMER'),
    const CustomTab(title: 'SUPPLIER')
  ];

  List<Widget> get tabs => _tabs;

  String _selectedCustomerCategory = 'Customer';
  String get selectedCustomerCategory => _selectedCustomerCategory;

  void updateCustomerCategory(String? category) {
    _selectedCustomerCategory = category!;
    notifyListeners();
  }

  final List<List> _reminderDateFilter = [
    ['Today', false],
    ['Pending', false],
    ['Upcoming', false],
  ];

  List<List> get reminderDateFilter => _reminderDateFilter;

  void updateReminderFilter(int index) {
    _reminderDateFilter[index][1] = !_reminderDateFilter[index][1];
    notifyListeners();
  }

  final List<String> _sortByFilter = [
    'Name',
    'Amount',
    'Latest',
  ];

  List<String> get sortByFilter => _sortByFilter;

  String _selectedSortByFilter = 'Latest';
  String get selectedSortByFilter => _selectedSortByFilter;

  void updatesortByFilter(String? filter) {
    _selectedSortByFilter = filter!;
    notifyListeners();
  }

  void resetFilter() {
    for (var element in _reminderDateFilter) {
      element[1] = false;
    }
    _selectedSortByFilter = 'Latest';
    notifyListeners();
  }

  bool _isAppLockEnabled = false;
  bool get isAppLockEnabled => _isAppLockEnabled;

  bool _isPaymentPasswordEnabled = false;
  bool get isPaymentPasswordEnabled => _isPaymentPasswordEnabled;

  bool _isFingerprintEnabled = false;
  bool get isFingerprintEnabled => _isFingerprintEnabled;

  void toggleSwitch(SwitchType type) {
    switch (type) {
      case SwitchType.appLock:
        _isAppLockEnabled = !_isAppLockEnabled;
        break;

      case SwitchType.paymentPassword:
        _isPaymentPasswordEnabled = !_isPaymentPasswordEnabled;
        break;

      case SwitchType.fingerPrint:
        _isFingerprintEnabled = !_isFingerprintEnabled;
        break;
    }

    notifyListeners();
  }
  
  Locale _currentLocale = Locale('en', 'US');
  // Getter for current locale
  Locale get currentLocale => _currentLocale;
  // Your existing language list with the `Locale` objects for each language
  final List<List> languageList = [
    ['English', true, Locale('en', 'US')],
    ['हिंदी', false, Locale('hi', 'IN')],
    ['ਪੰਜਾਬੀ', false, Locale('pa', 'IN')],
    ['मराठी', false, Locale('mr', 'IN')],
    ['ગુજરાતી', false, Locale('gu', 'IN')],
    ['ಕನ್ನಡ', false, Locale('kn', 'IN')],
    ['தமிழ்', false, Locale('ta', 'IN')],
    ['తెలుగు', false, Locale('te', 'IN')],
    ['অসমীয়া', false, Locale('as', 'IN')],
  ];

  // Function to update the language
  Future<void> updateAppLanguage(String language) async {
    // Find the Locale object based on the language
    Locale selectedLocale = _getLocaleForLanguage(language);

    // If the locale changes, update and notify listeners
    if (_currentLocale != selectedLocale) {
      _currentLocale = selectedLocale;
      await _saveLocaleToSharedPreferences(language);


      // Update the language selection state in languageList
      for (var lang in languageList) {
        lang[1] = lang[0] == language; // Set the selected language to true
      }
      
      // Notify all listeners that the language has changed
      notifyListeners();
    }
  }
  Future<void> loadLocaleFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language') ?? 'English'; // Default to English if not found
    _currentLocale = _getLocaleForLanguage(savedLanguage);
    notifyListeners();
  }

  // Save the selected language to shared preferences
  Future<void> _saveLocaleToSharedPreferences(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }


  // Helper function to return the Locale based on the selected language
  Locale _getLocaleForLanguage(String language) {
    switch (language) {
      case 'English':
        return Locale('en', 'US');
      case 'ಕನ್ನಡ':
        return Locale('kn', 'IN');
      case 'हिंदी':
        return Locale('hi', 'IN');
      case 'मराठी':
        return Locale('mr', 'IN');
      case 'ગુજરાતી':
        return Locale('gu', 'IN');
      case 'தமிழ்':
        return Locale('ta', 'IN');
      case 'తెలుగు':
        return Locale('te', 'IN');
      case 'অসমীয়া':
        return Locale('as', 'IN');
      case 'ਪੰਜਾਬੀ':
        return Locale('pa', 'IN');
      default:
        return Locale('en', 'US'); // Default to English
    }
  }


  String _selectedBusinessType = 'Personal Use';
  String get selectedBusinessType => _selectedBusinessType;

  final List<List> _businessTypes = [
    ['Personal Use', 'personal', true],
    ['Retail Shop', 'retail', false],
    ['Wholesale/Distributor', 'wholesale', false],
    ['Online Services', 'online', false],
  ];

  List<List> get businessTypes => _businessTypes;

  void updateBusinessType(String type) {
    for (var element in _businessTypes) {
      if (element[0] != type) {
        element[2] = false;
      } else {
        element[2] = true;
        _selectedBusinessType = element[0];
      }
    }

    notifyListeners();
  }

  String _selectedBusinessCategory = 'Select Category';
  String get selectedBusinessCategory => _selectedBusinessCategory;

  final List<List> _businessCategories = [
    ['Apparels Store', 'apparel', false],
    ['Eatery', 'eatery', false],
    ['Electronics', 'electronics', false],
    ['Fruit Shop', 'fruit', false],
    ['Vegetable Shop', 'vegetable', false],
    ['Medical Store', 'medicine', false],
    ['Mobile Recharge', 'recharge', false],
    ['Financial Services', 'profit', false],
    ['Fancy', 'mask', false],
    ['Kirana', 'groceries', false],
    ['Hardware', 'tools', false],
    ['Hotel', 'hotel', false],
    ['Jewellery', 'jewellery', false],
    ['Photo Studio', 'studio', false],
    ['Repair Services', 'repair', false],
    ['School', 'school', false],
    ['Transport', 'transport', false],
    ['Travel Agent', 'travel', false],
    ['Other', 'other', false],
  ];

  List<List> get businessCategories => _businessCategories;

  void updateBusinessCategory(String type) {
    for (var element in _businessCategories) {
      if (element[0] != type) {
        element[2] = false;
      } else {
        element[2] = true;
        _selectedBusinessCategory = element[0];
      }
    }

    notifyListeners();
  }

  String _activePlan = 'FREE';
  String get activePlan => _activePlan;

  void updatePlan() {
    _activePlan = _activePlan == 'FREE' ? 'Premium' : 'FREE';
    notifyListeners();
  }

  
}
