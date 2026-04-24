import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), backgroundColor: Colors.purple),
      body: Center(child: Text('Settings', style: TextStyle(fontSize: 24))),
    );
  }
}