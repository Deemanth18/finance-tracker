import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'helpers.dart';

Future<void> generatePDF(List expenses) async {
  final pdf = pw.Document();
  var total = 0.0;

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Finance Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            ...expenses.map((e) {
              final amount = double.tryParse(e['amount'].toString()) ?? 0;
              total += amount;

              return pw.Text(
                '${formatCurrency(amount)} - ${e['category']}',
                style: pw.TextStyle(fontSize: 16),
              );
            }),
            pw.SizedBox(height: 20),
            pw.Text(
              'Total: ${formatCurrency(total)}',
              style: pw.TextStyle(fontSize: 18),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
