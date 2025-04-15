class SoilTestReport {
  double phLevel;
  double nitrogenContent;
  double phosphorusContent;
  double potassiumContent;
  String testDate;

  SoilTestReport({
    required this.phLevel,
    required this.nitrogenContent,
    required this.phosphorusContent,
    required this.potassiumContent,
    required this.testDate,
  });

  // Convert the object to a map to save it to a database or API
  Map<String, dynamic> toMap() {
    return {
      'phLevel': phLevel,
      'nitrogenContent': nitrogenContent,
      'phosphorusContent': phosphorusContent,
      'potassiumContent': potassiumContent,
      'testDate': testDate,
    };
  }

  // A factory constructor to create a SoilTestReport from a map (retrieved from DB or API)
  factory SoilTestReport.fromMap(Map<String, dynamic> map) {
    return SoilTestReport(
      phLevel: map['phLevel'],
      nitrogenContent: map['nitrogenContent'],
      phosphorusContent: map['phosphorusContent'],
      potassiumContent: map['potassiumContent'],
      testDate: map['testDate'],
    );
  }
}
