import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:original/pages/User/user_report/soilTestReport_Model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportDetailScreen extends StatelessWidget {
  final SoilTestReport report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.green.shade700;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Soil Test Report'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReportHeader(primaryColor),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Farm Information',
              children: [
                _buildInfoTile('Location', report.location, Icons.location_on),
                _buildInfoTile('Test Date', report.testDate, Icons.calendar_today),
                _buildInfoTile('Status', report.status, Icons.assignment_turned_in),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Soil Nutrient Levels',
              children: [
                _buildInfoTile('pH Level', report.phLevel.toString(), FontAwesomeIcons.flask),
                _buildInfoTile('Nitrogen', report.nitrogen.toString(), FontAwesomeIcons.leaf),
                _buildInfoTile('Phosphorus', report.phosphorus.toString(), FontAwesomeIcons.seedling),
                _buildInfoTile('Potassium', report.potassium.toString(), FontAwesomeIcons.tint),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
              onPressed: () async {
                final pdf = await _generatePDF();
                await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Soil Health Report',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 4),
          Text(
            'Detailed analysis of your soil sample',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Future<pw.Document> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Soil Health Report', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Detailed analysis of your soil sample', style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 20),

            pw.Text('Farm Information', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildPDFRow('Location', report.location),
            _buildPDFRow('Test Date', report.testDate),
            _buildPDFRow('Status', report.recommendations),

            pw.SizedBox(height: 20),
            pw.Text('Soil Nutrient Levels', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildPDFRow('pH Level', report.phLevel.toString()),
            _buildPDFRow('Nitrogen', report.nitrogen.toString()),
            _buildPDFRow('Phosphorus', report.phosphorus.toString()),
            _buildPDFRow('Potassium', report.potassium.toString()),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildPDFRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:original/pages/User/user_report/soilTestReport_Model.dart';

// class ReportDetailScreen extends StatelessWidget {
//   final SoilTestReport report;

//   const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Soil Test Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text("Farm Location: ${report.location}"),
//             Text("Test Date: ${report.testDate}"),
//             Text("Status: ${report.recommendations}"),
//             const SizedBox(height: 10),
//             Text("pH Level: ${report.phLevel}"),
//             Text("Nitrogen: ${report.nitrogen}"),
//             Text("Phosphorus: ${report.phosphorus}"),
//             Text("Potassium: ${report.potassium}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
