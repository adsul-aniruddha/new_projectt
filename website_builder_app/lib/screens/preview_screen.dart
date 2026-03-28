import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;

    final url = "http://127.0.0.1:8081/site/$id";

    return Scaffold(
      appBar: AppBar(title: Text("Website Preview 🌐")),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.open_in_browser),
          label: Text("Open Website"),
          onPressed: () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
        ),
      ),
    );
  }
}