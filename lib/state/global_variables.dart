
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState extends ChangeNotifier {
  String _clientName='';
  String _phoneNumber='';
  String _password='';
  String _address='';
  String _gst='';
  String? _profileImagePath;
  String _businessname='';
  double _totalCustomerAmount=0.0;
  double _totalSupplierAmount=0.0;
  String? _clientId;
  List<String> _customerIds = [];

  // Separate ledger amounts for customers and suppliers
  Map<String, Map<String, double>> _customerLedgerAmounts = {};
  Map<String, Map<String, double>> _supplierLedgerAmounts = {};
  
  int? _signInTime;
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  bool _isConnected = false; // Track if the device is connected
  bool _isDarkMode = false;

  


  String? get clientId => _clientId;
  List<String> get customerIds => _customerIds;
  Map<String, Map<String, double>> get customerLedgerAmounts => _customerLedgerAmounts;
  Map<String, Map<String, double>> get supplierLedgerAmounts => _supplierLedgerAmounts;
  int? get signInTime => _signInTime;
  String get clientName => _clientName;
  String get phoneNumber => _phoneNumber;
  String get password => _password;
  String get address => _address;
  String get gst => _gst;
  String get businessname => _businessname;
  String? get profileImagePath => _profileImagePath;
  double get totalCustomerAmount => _totalCustomerAmount;
  double get totalSupplierAmount => _totalSupplierAmount;

  ConnectivityResult get connectivityStatus => _connectivityStatus;
  bool get isConnected => _isConnected;
  bool get isDarkMode => _isDarkMode;

  
  AppState() {
    loadProfileImage();
    loadFromPrefs();  // Load data on initialization
    _initializeConnectivity();
  }
    // Listen to connectivity changes
 void _initializeConnectivity() {
    // Get initial connectivity status
    Connectivity().checkConnectivity().then((List<ConnectivityResult> result) {
      // Check if any element of the list is not ConnectivityResult.none
      _connectivityStatus = result.first;  // We'll work with the first element of the list
      _isConnected = _connectivityStatus != ConnectivityResult.none;
      notifyListeners();
    });

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      // Get the first result from the list, as it should only have one element
      _connectivityStatus = result.first;
      _isConnected = _connectivityStatus != ConnectivityResult.none;
      notifyListeners();  // Notify listeners on status change
    });
  }


  // Method to check network connectivity before making API calls
  Future<bool> checkConnectivity() async {
    if (_isConnected) {
      return true;  // Connected, proceed with API call
    } else {
      // Show no connectivity animation if the device is offline
      showNetworkErrorAnimation();
      return false;  // Not connected
    }
  }

  // Show network error animation when disconnected
  void showNetworkErrorAnimation() {
    print('No internet connection, showing animation...');
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }


  // Store clientId
  void setClientId(String id) async {
    _clientId = id;
    _signInTime = DateTime.now().millisecondsSinceEpoch; // Save current timestamp
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('clientId', id);
    await prefs.setInt('signInTime', _signInTime!);  // Save the sign-in timestamp
  }
  Future<void> setProfileImagePath(String imagePath) async {
    _profileImagePath = imagePath;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImagePath', imagePath);  // Store the image path
    notifyListeners();
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    _profileImagePath = prefs.getString('profileImagePath');
    notifyListeners();
  }


  void setClientName(String name) async {
    _clientName = name;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('clientName', name);
  }
  void setAddress(String address) async {
    _address = address;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('address', address);
  }  
  void setGst(String gst) async {
    _gst = gst;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gst', gst);
  }
  void setPhoneNumber(String phone) async {
    _phoneNumber = phone;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneNumber', phone);
  }

  void setPassword(String password) async {
    _password = password;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }
  void setBusinessName(String businessname) async {
    _businessname = businessname;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('business_name', businessname);
  }

  // Store customerIds
  void setCustomerIds(List<String> ids) async {
    _customerIds = ids;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('customerIds', ids);
  }
  void setTotalCustomerAmount(double totalCustomerAmount) async {
    _totalCustomerAmount = totalCustomerAmount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalCustomerAmount', totalCustomerAmount);
  }
  void setTotalSupplierAmount(double totalSupplierAmount) async {
    _totalSupplierAmount = totalSupplierAmount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('totalSupplierAmount', totalSupplierAmount);
  }

  // Store ledger amounts for customer
  void setCustomerLedgerAmount(String customerId, String ledgerId, double totalAmount) async {
    if (!_customerLedgerAmounts.containsKey(customerId)) {
      _customerLedgerAmounts[customerId] = {};
    }
    _customerLedgerAmounts[customerId]![ledgerId] = totalAmount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('customerLedgerAmounts', jsonEncode(_customerLedgerAmounts));
  }

  // Store ledger amounts for supplier
  void setSupplierLedgerAmount(String supplierId, String ledgerId, double totalAmount) async {
    if (!_supplierLedgerAmounts.containsKey(supplierId)) {
      _supplierLedgerAmounts[supplierId] = {};
    }
    _supplierLedgerAmounts[supplierId]![ledgerId] = totalAmount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('supplierLedgerAmounts', jsonEncode(_supplierLedgerAmounts));
  }

  // Load data from SharedPreferences
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    _clientId = prefs.getString('clientId');
    _customerIds = prefs.getStringList('customerIds') ?? [];

    _clientName = prefs.getString('clientName') ?? '';
    _phoneNumber = prefs.getString('phoneNumber') ?? '';
    _password = prefs.getString('password') ?? '';
    _businessname = prefs.getString('business_name') ?? '';
    _address = prefs.getString('address') ?? '';
    _gst = prefs.getString('gst') ?? '';
    _totalCustomerAmount = prefs.getDouble('totalCustomerAmount') ?? 0.0;
    _totalSupplierAmount = prefs.getDouble('totalSupplierAmount') ?? 0.0;
    
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    String? customerLedgerData = prefs.getString('customerLedgerAmounts');
    if (customerLedgerData != null) {
      Map<String, dynamic> decoded = jsonDecode(customerLedgerData);
      _customerLedgerAmounts = decoded.map((key, value) => MapEntry(
            key,
            Map<String, double>.from(value),
          ));
    }

    String? supplierLedgerData = prefs.getString('supplierLedgerAmounts');
    if (supplierLedgerData != null) {
      Map<String, dynamic> decoded = jsonDecode(supplierLedgerData);
      _supplierLedgerAmounts = decoded.map((key, value) => MapEntry(
            key,
            Map<String, double>.from(value),
          ));
    }

    notifyListeners();
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Logout: Clears the stored data and sign-in timestamp
  Future<void> logout() async {
    _signInTime = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('signInTime');
  }

  // Check if the user is signed in and if the session is still valid (30 days max)
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final signInTime = prefs.getInt('signInTime');

    if (signInTime == null) {
      return false;  // No sign-in timestamp, user has not logged in
    }

    // Get the current time and calculate the difference
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final diffInDays = (currentTime - signInTime) / (1000 * 60 * 60 * 24); // Difference in days

    if (diffInDays <= 30) {
      return true;  // User is still logged in within the 30-day period
    } else {
      return false;  // More than 30 days have passed, user needs to sign in again
    }
  }
}
