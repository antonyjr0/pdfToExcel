import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerWidget extends StatelessWidget {
  final Function(String?) onFileSelected;
  final String? selectedFilePath;

  const FilePickerWidget({
    super.key,
    required this.onFileSelected,
    this.selectedFilePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedFilePath != null 
                  ? Colors.green 
                  : Colors.grey.shade400,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: selectedFilePath != null 
                ? Colors.green.shade50 
                : Colors.grey.shade50,
          ),
          child: Column(
            children: [
              Icon(
                selectedFilePath != null 
                    ? Icons.check_circle 
                    : Icons.file_upload,
                size: 48,
                color: selectedFilePath != null 
                    ? Colors.green 
                    : Colors.grey.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                selectedFilePath != null 
                    ? 'File selezionato:' 
                    : 'Nessun file selezionato',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: selectedFilePath != null 
                      ? Colors.green.shade800 
                      : Colors.grey.shade700,
                ),
              ),
              if (selectedFilePath != null) ...[
                const SizedBox(height: 4),
                Text(
                  _getFileName(selectedFilePath!),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Seleziona PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (selectedFilePath != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => onFileSelected(null),
                icon: const Icon(Icons.clear),
                tooltip: 'Rimuovi file',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        onFileSelected(result.files.single.path!);
      }
    } catch (e) {
      print('Errore nella selezione del file: $e');
      // In un'app reale, mostrerei un messaggio di errore all'utente
    }
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }
}