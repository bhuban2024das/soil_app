class SoilTestReport {
  final int id;
  final String location;
  final String testDate;
  final double phLevel;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final String recommendations;
  final String status;

  SoilTestReport({
    required this.id,
    required this.location,
    required this.testDate,
    required this.phLevel,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.recommendations,
    required this.status,
  });

  factory SoilTestReport.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return SoilTestReport(
      id: json['soilTestId'] ?? 0,
      location: json['farmLocation'] ?? '',
      testDate: json['testDate'] ?? '',
      phLevel: parseDouble(json['phLevel']),
      nitrogen: parseDouble(json['nitrogen']),
      phosphorus: parseDouble(json['phosphorus']),
      potassium: parseDouble(json['potassium']),
      recommendations: json['soilPreparations'] ?? '',
      status: json['status'],
    );
  }
}
