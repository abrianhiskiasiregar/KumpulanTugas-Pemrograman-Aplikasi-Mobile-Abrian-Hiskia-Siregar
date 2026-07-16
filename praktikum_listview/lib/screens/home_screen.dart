import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(
      50,
      (i) => "Data Pengguna Ke-${i + 1}",
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pengguna")),

      body: ListView.builder(
        itemCount: items.length,

        itemBuilder: (context, index) {
          final currentItem = items[index];

          return ListTile(
            leading: const Icon(Icons.person),

            title: Text(currentItem),

            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: currentItem);
            },
          );
        },
      ),
    );
  }
}
