import 'package:flutter/material.dart';

class GoodScrollScreen extends StatelessWidget {
  const GoodScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate 10.000 data dummy
    final List<String> items = List.generate(10000, (i) => "Item Ke-${i + 1}");

    return Scaffold(
      appBar: AppBar(title: const Text('Good Scroll (ListView.separated)')),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) {
          return const Divider(color: Colors.grey, height: 1);
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.label_important, color: Colors.blue),
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}