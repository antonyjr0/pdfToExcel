import 'package:flutter/material.dart';
import 'package:pdf_to_excel_converter/services/pdf_converter_services.dart';
import '../widgets/file_picker_widget.dart';
import '../widgets/conversion_status_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PdfConverterService _converterService = PdfConverterService();
  String? _selectedFilePath;
  bool _isConverting = false;
  String? _statusMessage;
  String? _outputPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF to Excel Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Seleziona un file PDF da convertire in Excel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            FilePickerWidget(
              onFileSelected: (filePath) {
                setState(() {
                  _selectedFilePath = filePath;
                  _statusMessage = null;
                  _outputPath = null;
                });
              },
              selectedFilePath: _selectedFilePath,
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: (_selectedFilePath != null && !_isConverting) 
                  ? _convertFile 
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isConverting 
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Conversione in corso...'),
                      ],
                    )
                  : const Text(
                      'Converti in Excel',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            
            const SizedBox(height: 32),
            
            ConversionStatusWidget(
              statusMessage: _statusMessage,
              outputPath: _outputPath,
              onShareFile: _outputPath != null ? () => _shareFile(_outputPath!) : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _convertFile() async {
    if (_selectedFilePath == null) return;

    setState(() {
      _isConverting = true;
      _statusMessage = 'Inizio conversione...';
    });

    try {
      final result = await _converterService.convertPdfToExcel(_selectedFilePath!);
      
      setState(() {
        _isConverting = false;
        _statusMessage = 'Conversione completata con successo!';
        _outputPath = result.outputPath;
      });
    } catch (e) {
      setState(() {
        _isConverting = false;
        _statusMessage = 'Errore durante la conversione: $e';
        _outputPath = null;
      });
    }
  }

  Future<void> _shareFile(String filePath) async {
    await _converterService.shareFile(filePath);
  }
}