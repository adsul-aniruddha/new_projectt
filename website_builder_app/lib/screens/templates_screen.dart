import 'package:flutter/material.dart';

class TemplatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Templates'), backgroundColor: Colors.orange),
      body: Center(child: Text('Browse Templates', style: TextStyle(fontSize: 24))),
    );
  }
}