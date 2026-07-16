import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Stateless Widget utama
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Counter Saya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Halaman Utama Counter'),
    );
  }
}

// Stateful Widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Tambah
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Kurang
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Kamu telah menekan tombol sebanyak:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('Tambah'),
                ),
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Text('Kurang'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}