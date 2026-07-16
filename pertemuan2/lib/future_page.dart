import 'package:flutter/material.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String _statusText = 'Tekan tombol untuk mengambil data';
  bool _isLoading = false;

  // Simulasi ambil data
  Future<String> _simulasiAmbilData() async {
    await Future.delayed(const Duration(seconds: 3));

    if (DateTime.now().second % 5 == 0) {
      throw Exception('Gagal mengambil data. Periksa koneksi Anda.');
    }

    return 'Selamat Datang di Flutter!';
  }

  void _ambilData() async {
    setState(() {
      _isLoading = true;
      _statusText = 'Mengambil data...';
    });

    try {
      String data = await _simulasiAmbilData();

      setState(() {
        _statusText = 'Data berhasil diambil: $data';
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _statusText = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Future'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _ambilData,
                child: const Text('Ambil Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}