import 'package:flutter/material.dart';

class BadScrollScreen extends StatelessWidget {
  const BadScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(10000, (i) => "Item Ke-${i + 1}");

    return Scaffold(
      appBar: AppBar(title: const Text("Bad Scroll")),

      body: SingleChildScrollView(
        child: Column(
          children: items.map((item) {
            return ListTile(
              leading: const Icon(Icons.label),
              title: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
