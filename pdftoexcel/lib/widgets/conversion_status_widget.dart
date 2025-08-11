import 'package:flutter/material.dart';

class ConversionStatusWidget extends StatelessWidget {
  final String? statusMessage;
  final String? outputPath;
  final VoidCallback? onShareFile;

  const ConversionStatusWidget({
    super.key,
    this.statusMessage,
    this.outputPath,
    this.onShareFile,
  });

  @override
  Widget build(BuildContext context) {
    if (statusMessage == null) {
      return const SizedBox.shrink();
    }

    final bool isSuccess = outputPath != null;
    final bool isError = statusMessage!.toLowerCase().contains('errore');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isSuccess, isError),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBorderColor(isSuccess, isError),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIcon(isSuccess, isError),
                color: _getIconColor(isSuccess, isError),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusMessage!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _getTextColor(isSuccess, isError),
                  ),
                ),
              ),
            ],
          ),
          
          if (outputPath != null) ...[
            const SizedBox(height: 12),
            Text(
              'File salvato in:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getFileName(outputPath!),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShareFile,
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Condividi file'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(bool isSuccess, bool isError) {
    if (isSuccess) return Colors.green.shade50;
    if (isError) return Colors.red.shade50;
    return Colors.blue.shade50;
  }

  Color _getBorderColor(bool isSuccess, bool isError) {
    if (isSuccess) return Colors.green.shade300;
    if (isError) return Colors.red.shade300;
    return Colors.blue.shade300;
  }

  Color _getIconColor(bool isSuccess, bool isError) {
    if (isSuccess) return Colors.green.shade600;
    if (isError) return Colors.red.shade600;
    return Colors.blue.shade600;
  }

  Color _getTextColor(bool isSuccess, bool isError) {
    if (isSuccess) return Colors.green.shade800;
    if (isError) return Colors.red.shade800;
    return Colors.blue.shade800;
  }

  IconData _getIcon(bool isSuccess, bool isError) {
    if (isSuccess) return Icons.check_circle;
    if (isError) return Icons.error;
    return Icons.info;
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }
}