import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text(
                    '  ^^     /======>\n (00)   /      /\n@@=====>\n    J        J',
                   ),
                ];
              );  
            }
        ),
      ),
    );
  }
}
