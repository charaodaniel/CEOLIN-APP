import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/ride_history_model.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class ReportGenerator {

  Future<void> generateCsv(List<RideHistory> rides, BuildContext context) async {
    if (rides.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há dados para exportar.')),
      );
      return;
    }

    List<List<dynamic>> rows = [];
    rows.add(["Destino", "Data", "Valor (R\$)"]);

    for (var ride in rides) {
      rows.add([
        ride.destination,
        DateFormat('dd/MM/yyyy HH:mm').format(ride.date),
        ride.fare.toStringAsFixed(2).replaceAll('.', ',')
      ]);
    }

    final double totalFare = rides.fold(0.0, (sum, item) => sum + item.fare);
    rows.add(["TOTAL", "", totalFare.toStringAsFixed(2).replaceAll('.', ',')]);

    String csv = const ListToCsvConverter().convert(rows, fieldDelimiter: ';');

    final fileName = "relatorio_corridas_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv";
    final bytes = utf8.encode(csv);

    if (!context.mounted) return; // Mounted check before using context in the next method
    await _saveAndOpenFile(fileName, bytes, context);
  }

  Future<void> generatePdf(List<RideHistory> rides, BuildContext context, {DateTimeRange? dateRange}) async {
     if (rides.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há dados para exportar.')),
      );
      return;
    }

    final pdf = pw.Document();
    final double totalFare = rides.fold(0.0, (sum, item) => sum + item.fare);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                 pw.Text('Relatório de Corridas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                 if (dateRange != null)
                  pw.Text(
                    'Período: ${DateFormat('dd/MM/yyyy').format(dateRange.start)} - ${DateFormat('dd/MM/yyyy').format(dateRange.end)}',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)
                  ),
                  pw.SizedBox(height: 20),
              ]
            )
          ),
          pw.Table.fromTextArray(
            headers: ['Destino', 'Data', 'Valor (R\$)'],
            data: rides.map((ride) => [
              ride.destination,
              DateFormat('dd/MM/yy HH:mm').format(ride.date),
              'R\$ ${ride.fare.toStringAsFixed(2).replaceAll('.', ',')}',
            ]).toList(),
             cellAlignment: pw.Alignment.centerLeft,
             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
             headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
             border: pw.TableBorder.all(),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Total das Corridas: ',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('R\$ ${totalFare.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
            ],
          )
        ],
      ),
    );

    final fileName = "relatorio_corridas_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf";
    final bytes = await pdf.save();

    if (!context.mounted) return; // FIX: Added mounted check after async gap.
    await _saveAndOpenFile(fileName, bytes, context);
  }

  Future<void> _saveAndOpenFile(String fileName, List<int> bytes, BuildContext context) async {
    if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
            status = await Permission.storage.request();
        }

        if (!context.mounted) return;
        if (status.isPermanentlyDenied) {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permissão de armazenamento negada permanentemente. Por favor, habilite nas configurações.')),
            );
            return;
        }
         if (!status.isGranted) {
             ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permissão de armazenamento é necessária para salvar o arquivo.')),
            );
            return;
        }
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      
      if (!context.mounted) return;
      final result = await OpenFile.open(path);
      
      if (result.type != ResultType.done) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o arquivo: ${result.message}')),
        );
      }
    } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar ou abrir o arquivo: $e')),
      );
    }
  }
}
