class SoilTestRequest {
  final int soilTestId;
  final String userName;
  final String? userMobileNumber;
  final String farmLocation;
  final String testDate;
  final String status;
  final double? phLevel;
  final double? nitrogen;
  final double? phosphorus;
  final double? potassium;
  final List<String> recommendedCrops;
  final List<String> recommendedProducts;

  SoilTestRequest({
    required this.soilTestId,
    required this.userName,
    required this.userMobileNumber,
    required this.farmLocation,
    required this.testDate,
    required this.status,
    this.phLevel,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    required this.recommendedCrops,
    required this.recommendedProducts,
  });

  factory SoilTestRequest.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    }

    return SoilTestRequest(
      soilTestId: json['soilTestId'] ?? 0,
      userName: json['userName'] ?? '',
      userMobileNumber: json['userMobileNumber'],
      farmLocation: json['farmLocation'] ?? '',
      testDate: json['testDate'] ?? '',
      status: json['status'] ?? '',
      phLevel: parseDouble(json['phLevel']),
      nitrogen: parseDouble(json['nitrogen']),
      phosphorus: parseDouble(json['phosphorus']),
      potassium: parseDouble(json['potassium']),
      recommendedCrops: parseStringList(json['recommendedCrops']),
      recommendedProducts: parseStringList(json['recommendedProducts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soilTestId': soilTestId,
      'userName': userName,
      'userMobileNumber': userMobileNumber,
      'farmLocation': farmLocation,
      'testDate': testDate,
      'status': status,
      'phLevel': phLevel,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'recommendedCrops': recommendedCrops,
      'recommendedProducts': recommendedProducts,
    };
  }
}

// class SoilTestRequest {
//   final int id;
//   final String userName;
//   final String? userMobileNumber;
//   final String farmLocation;
//   final String testDate;
//   final String status;
//   final double? phLevel;
//   final double? nitrogen;
//   final double? phosphorus;
//   final double? potassium;

//   SoilTestRequest({
//     required this.id,
//     required this.userName,
//     required this.userMobileNumber,
//     required this.farmLocation,
//     required this.testDate,
//     required this.status,
//     this.phLevel,
//     this.nitrogen,
//     this.phosphorus,
//     this.potassium,
//   });

//   factory SoilTestRequest.fromJson(Map<String, dynamic> json) {
//     return SoilTestRequest(
//       id: json['id'],
//       userName: json['userName'] ?? '',
//       userMobileNumber: json['userMobileNumber'],
//       farmLocation: json['farmLocation'] ?? '',
//       testDate: json['testDate'] ?? '',
//       status: json['status'] ?? '',
//       phLevel: (json['phLevel'] != null) ? json['phLevel'].toDouble() : null,
//       nitrogen: (json['nitrogen'] != null) ? json['nitrogen'].toDouble() : null,
//       phosphorus:
//           (json['phosphorus'] != null) ? json['phosphorus'].toDouble() : null,
//       potassium:
//           (json['potassium'] != null) ? json['potassium'].toDouble() : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userName': userName,
//       'userMobileNumber': userMobileNumber,
//       'farmLocation': farmLocation,
//       'testDate': testDate,
//       'status': status,
//       'phLevel': phLevel,
//       'nitrogen': nitrogen,
//       'phosphorus': phosphorus,
//       'potassium': potassium,
//     };
//   }
// }
