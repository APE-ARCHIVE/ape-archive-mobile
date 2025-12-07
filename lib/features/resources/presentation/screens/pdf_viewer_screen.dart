import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String streamingUrl;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.streamingUrl,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  PdfTextSearchResult? _searchResult;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search in PDF...',
                  border: InputBorder.none,
                ),
                onSubmitted: (text) {
                  _searchResult = _pdfViewerController.searchText(text);
                },
              )
            : Text(widget.title),
        actions: [
          if (_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                // Navigate to previous search result
                _searchResult?.previousInstance();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                // Navigate to next search result
                _searchResult?.nextInstance();
              },
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _pdfViewerController.clearSelection();
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ],
        ],
      ),
      body: SfPdfViewer.network(
        widget.streamingUrl,
        controller: _pdfViewerController,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: true,
      ),
    );
  }
}
