class User {
  // Basic Information
  String fullName;
  String mobileNumber;
  String address;
  String? email;

  // Authentication & Access
  bool otpVerified;
  DateTime signupDate;
  DateTime lastLoginDate;

  // Soil Testing Data
  List<String> soilTestRequests;
  List<String> soilTestReportIds;
  Map<String, dynamic> soilTestReportData;

  // Crop Advisory & Recommendations
  List<String> recommendedCrops;
  String soilPreparationGuide;
  List<String> recommendedProducts;

  // Orders & Transactions
  List<Map<String, dynamic>> orderHistory;
  String orderStatus;
  Map<String, dynamic> paymentDetails;

  // Additional Information
  String preferredLanguage;
  double farmSize;
  List<String> cropsGrown;

  User({
    required this.fullName,
    required this.mobileNumber,
    required this.address,
    this.email,
    required this.otpVerified,
    required this.signupDate,
    required this.lastLoginDate,
    required this.soilTestRequests,
    required this.soilTestReportIds,
    required this.soilTestReportData,
    required this.recommendedCrops,
    required this.soilPreparationGuide,
    required this.recommendedProducts,
    required this.orderHistory,
    required this.orderStatus,
    required this.paymentDetails,
    required this.preferredLanguage,
    required this.farmSize,
    required this.cropsGrown,
  });

  // Convert User object to Map (for storage)
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'address': address,
      'email': email,
      'otpVerified': otpVerified,
      'signupDate': signupDate.toIso8601String(),
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'soilTestRequests': soilTestRequests,
      'soilTestReportIds': soilTestReportIds,
      'soilTestReportData': soilTestReportData,
      'recommendedCrops': recommendedCrops,
      'soilPreparationGuide': soilPreparationGuide,
      'recommendedProducts': recommendedProducts,
      'orderHistory': orderHistory,
      'orderStatus': orderStatus,
      'paymentDetails': paymentDetails,
      'preferredLanguage': preferredLanguage,
      'farmSize': farmSize,
      'cropsGrown': cropsGrown,
    };
  }

  // Create User object from Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      email: json['email'],
      otpVerified: json['otpVerified'],
      signupDate: DateTime.parse(json['signupDate']),
      lastLoginDate: DateTime.parse(json['lastLoginDate']),
      soilTestRequests: List<String>.from(json['soilTestRequests']),
      soilTestReportIds: List<String>.from(json['soilTestReportIds']),
      soilTestReportData: Map<String, dynamic>.from(json['soilTestReportData']),
      recommendedCrops: List<String>.from(json['recommendedCrops']),
      soilPreparationGuide: json['soilPreparationGuide'],
      recommendedProducts: List<String>.from(json['recommendedProducts']),
      orderHistory: List<Map<String, dynamic>>.from(json['orderHistory']),
      orderStatus: json['orderStatus'],
      paymentDetails: Map<String, dynamic>.from(json['paymentDetails']),
      preferredLanguage: json['preferredLanguage'],
      farmSize: json['farmSize'].toDouble(),
      cropsGrown: List<String>.from(json['cropsGrown']),
    );
  }
}
