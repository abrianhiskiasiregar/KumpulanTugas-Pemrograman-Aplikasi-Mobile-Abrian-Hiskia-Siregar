import 'package:flutter/material.dart';

class GoodScrollScreen extends StatelessWidget {
  const GoodScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(10000, (i) => "Item Ke-${i + 1}");

    return Scaffold(
      appBar: AppBar(title: const Text("ListView.separated")),

      body: ListView.separated(
        itemCount: items.length,

        separatorBuilder: (context, index) {
          return const Divider();
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
