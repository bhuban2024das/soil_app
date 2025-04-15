class SoilTestRequest {
  final int id;
  final String userName;
  final String? userMobileNumber;
  final String farmLocation;
  final String testDate;
  final String status;
  final double? phLevel;
  final double? nitrogen;
  final double? phosphorus;
  final double? potassium;

  SoilTestRequest({
    required this.id,
    required this.userName,
    required this.userMobileNumber,
    required this.farmLocation,
    required this.testDate,
    required this.status,
    this.phLevel,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
  });

  factory SoilTestRequest.fromJson(Map<String, dynamic> json) {
    return SoilTestRequest(
      id: json['id'],
      userName: json['userName'] ?? '',
      userMobileNumber: json['userMobileNumber'],
      farmLocation: json['farmLocation'] ?? '',
      testDate: json['testDate'] ?? '',
      status: json['status'] ?? '',
      phLevel: (json['phLevel'] != null) ? json['phLevel'].toDouble() : null,
      nitrogen: (json['nitrogen'] != null) ? json['nitrogen'].toDouble() : null,
      phosphorus:
          (json['phosphorus'] != null) ? json['phosphorus'].toDouble() : null,
      potassium:
          (json['potassium'] != null) ? json['potassium'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userMobileNumber': userMobileNumber,
      'farmLocation': farmLocation,
      'testDate': testDate,
      'status': status,
      'phLevel': phLevel,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
    };
  }
}
