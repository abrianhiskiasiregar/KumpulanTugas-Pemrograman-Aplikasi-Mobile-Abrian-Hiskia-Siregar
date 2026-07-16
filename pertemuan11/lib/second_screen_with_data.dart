import 'package:flutter/material.dart';

class SecondScreenWithData extends StatelessWidget {
  const SecondScreenWithData({super.key});

  @override
  Widget build(BuildContext context) {
    // MENANGKAP DATA yang dikirim dari halaman sebelumnya
    final String dataDiterima =
        ModalRoute.of(context)!.settings.arguments as String;

    // Data dikirim ke constructor kelas visual di bawah
    return DetailView(detailText: dataDiterima);
  }
}

// Widget Tampilan Utama yang menerima data melalui Constructor
class DetailView extends StatelessWidget {
  final String detailText; // Property penampung data

  // CONSTRUCTOR: Wajib menerima data string
  const DetailView({super.key, required this.detailText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Detail')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Menampilkan:\n$detailText',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}