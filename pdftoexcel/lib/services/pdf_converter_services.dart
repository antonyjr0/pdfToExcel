import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';

class ConversionResult {
  final String outputPath;
  final int rowsProcessed;
  final String fileName;

  ConversionResult({
    required this.outputPath,
    required this.rowsProcessed,
    required this.fileName,
  });
}

class PdfConverterService {
  /// Converte un file PDF in Excel
  Future<ConversionResult> convertPdfToExcel(String pdfPath) async {
    try {
      // 1. Estrai il testo dal PDF
      final extractedText = await _extractTextFromPdf(pdfPath);
      
      // 2. Processa il testo in righe
      final lines = _processTextToLines(extractedText);
      
      // 3. Crea il file Excel
      final outputPath = await _createExcelFile(lines, pdfPath);
      
      return ConversionResult(
        outputPath: outputPath,
        rowsProcessed: lines.length,
        fileName: _getOutputFileName(pdfPath),
      );
    } catch (e) {
      throw Exception('Errore nella conversione: $e');
    }
  }

  /// Estrae il testo dal PDF usando Syncfusion
  Future<String> _extractTextFromPdf(String pdfPath) async {
    try {
      // Leggi il file PDF
      final File file = File(pdfPath);
      final Uint8List bytes = await file.readAsBytes();
      
      // Carica il documento PDF
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      
      // Estrai il testo
      final String text = PdfTextExtractor.extractText(document);
      
      // Rilascia le risorse
      document.dispose();
      
      return text;
    } catch (e) {
      throw Exception('Impossibile leggere il PDF: $e');
    }
  }

  /// Processa il testo estratto in righe pulite
  List<List<String>> _processTextToLines(String text) {
    final lines = text.split('\n');
    final processedLines = <List<String>>[];
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isNotEmpty) {
        // Prova a dividere la riga in colonne usando spazi multipli o tab
        final columns = _splitIntoColumns(trimmedLine);
        processedLines.add(columns);
      }
    }
    
    return processedLines;
  }

  /// Divide una riga in colonne basandosi su separatori comuni
  List<String> _splitIntoColumns(String line) {
    // Prova diversi separatori
    if (line.contains('\t')) {
      return line.split('\t').map((s) => s.trim()).toList();
    } else if (line.contains('  ')) {
      // Dividi su spazi multipli
      return line.split(RegExp(r'\s{2,}')).map((s) => s.trim()).toList();
    } else if (line.contains(',')) {
      return line.split(',').map((s) => s.trim()).toList();
    } else if (line.contains(';')) {
      return line.split(';').map((s) => s.trim()).toList();
    } else {
      // Nessun separatore chiaro, restituisci l'intera riga come una colonna
      return [line];
    }
  }

  /// Crea il file Excel
  Future<String> _createExcelFile(List<List<String>> data, String originalPath) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    
    // Aggiungi i dati al foglio
    for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];
      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: rowIndex,
        ));
        cell.value = TextCellValue(row[colIndex]);
      }
    }
    
    // Ottieni il percorso di output
    final outputPath = await _getOutputPath(originalPath);
    
    // Salva il file
    final excelBytes = excel.save();
    if (excelBytes != null) {
      final file = File(outputPath);
      await file.writeAsBytes(excelBytes);
    }
    
    return outputPath;
  }

  /// Ottieni il percorso di output per il file Excel
  Future<String> _getOutputPath(String originalPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = _getOutputFileName(originalPath);
    return '${directory.path}/$fileName';
  }

  /// Genera il nome del file di output
  String _getOutputFileName(String originalPath) {
    final fileName = originalPath.split('/').last;
    final nameWithoutExtension = fileName.replaceAll('.pdf', '');
    return '${nameWithoutExtension}_converted.xlsx';
  }

  /// Condivide il file convertito
  Future<void> shareFile(String filePath) async {
    try {
      final result = await Share.shareXFiles(
        [XFile(filePath)],
        text: 'File Excel convertito da PDF',
      );
      
      if (result.status == ShareResultStatus.success) {
        print('File condiviso con successo');
      }
    } catch (e) {
      throw Exception('Errore durante la condivisione: $e');
    }
  }

  /// Verifica se un file esiste
  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  /// Ottieni informazioni sul file
  Future<Map<String, dynamic>> getFileInfo(String path) async {
    final file = File(path);
    final stat = await file.stat();
    
    return {
      'size': stat.size,
      'modified': stat.modified,
      'path': path,
    };
  }
}