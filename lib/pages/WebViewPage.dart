import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final String _url;

  WebViewPage(this._url);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _hasError = false;
  bool _isLoading = true;
  late String _url;

  @override
  void initState() {
    super.initState();
    _url = widget._url;
    if (!_url.startsWith('http://') && !_url.startsWith('https://')) {
      _url = 'https://$_url';
    }
    // No platform-specific initialization to avoid compile issues across versions.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              final uri = Uri.tryParse(_url);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cannot open URL')),
                );
              }
            },
          )
        ],
      ),
      body: _hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load page.'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.tryParse(_url);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text('Open in browser'),
                  )
                ],
              ),
            )
          : Stack(
              children: [
                WebView(
                  initialUrl: _url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) => setState(() => _isLoading = false),
                  onWebResourceError: (error) {
                    setState(() {
                      _hasError = true;
                      _isLoading = false;
                    });
                  },
                ),
                if (_isLoading) Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }
}
