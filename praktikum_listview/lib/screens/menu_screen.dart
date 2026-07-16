import 'package:flutter/material.dart';
import 'bad_scroll_screen.dart';
import 'good_scroll_screen.dart';
import 'home_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Praktikum Modul 11")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BadScrollScreen()),
                );
              },
              child: const Text("Praktikum 1 - Bad Scroll"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoodScrollScreen()),
                );
              },
              child: const Text("Praktikum 1 - Good Scroll"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text("Praktikum 2 - Navigation"),
            ),
          ],
        ),
      ),
    );
  }
}
