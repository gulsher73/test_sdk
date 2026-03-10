import 'package:flutter/material.dart';

@pragma('vm:entry-point')
void main() => runApp(const TestSDKApp());

class TestSDKApp extends StatelessWidget {
  const TestSDKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestSDK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HelloWorldScreen(),
    );
  }
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World SDK'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
