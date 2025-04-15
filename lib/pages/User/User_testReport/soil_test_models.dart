// models/soil_test_models.dart

class SoilTestSummary {
  final int id;
  final String location;
  final String testDate;
  final String status;

  SoilTestSummary({
    required this.id,
    required this.location,
    required this.testDate,
    required this.status,
  });

  factory SoilTestSummary.fromJson(Map<String, dynamic> json) {
    return SoilTestSummary(
      id: json['id'],
      location: json['location'],
      testDate: json['testDate'],
      status: json['status'],
    );
  }
}

class SoilTestDetail {
  final int id;
  final String location;
  final String testDate;
  final String status;
  final String phLevel;
  final String nitrogen;
  final String phosphorus;
  final String potassium;
  final String recommendation;

  SoilTestDetail({
    required this.id,
    required this.location,
    required this.testDate,
    required this.status,
    required this.phLevel,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.recommendation,
  });

  factory SoilTestDetail.fromJson(Map<String, dynamic> json) {
    return SoilTestDetail(
      id: json['id'],
      location: json['location'],
      testDate: json['testDate'],
      status: json['status'],
      phLevel: json['phLevel'],
      nitrogen: json['nitrogen'],
      phosphorus: json['phosphorus'],
      potassium: json['potassium'],
      recommendation: json['recommendation'],
    );
  }
}
