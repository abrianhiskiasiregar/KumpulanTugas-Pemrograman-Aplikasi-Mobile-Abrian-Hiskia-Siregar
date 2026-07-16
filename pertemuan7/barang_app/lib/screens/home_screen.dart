import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/barang.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _satuanController = TextEditingController();
  final _hargaController = TextEditingController();
  final _keteranganController = TextEditingController();

  List<Barang> listBarang = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final data = await DatabaseHelper.instance.getBarang();
    setState(() {
      listBarang = data.map((e) => Barang.fromMap(e)).toList();
    });
  }

  Future tambahData() async {
    final barang = Barang(
      kodeBarang: _kodeController.text,
      namaBarang: _namaController.text,
      satuan: _satuanController.text,
      harga: int.parse(_hargaController.text),
      keterangan: _keteranganController.text,
    );

    await DatabaseHelper.instance.insertBarang(barang.toMap());

    clearForm();
    loadData();
  }

  void clearForm() {
    _kodeController.clear();
    _namaController.clear();
    _satuanController.clear();
    _hargaController.clear();
    _keteranganController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Barang")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _kodeController, decoration: InputDecoration(labelText: "Kode Barang")),
            TextField(controller: _namaController, decoration: InputDecoration(labelText: "Nama Barang")),
            TextField(controller: _satuanController, decoration: InputDecoration(labelText: "Satuan")),
            TextField(controller: _hargaController, decoration: InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
            TextField(controller: _keteranganController, decoration: InputDecoration(labelText: "Keterangan")),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: tambahData,
              child: Text("Simpan"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listBarang.length,
                itemBuilder: (ctx, index) {
                  final item = listBarang[index];
                  return ListTile(
                    title: Text(item.namaBarang),
                    subtitle: Text("Harga: ${item.harga} | Satuan: ${item.satuan}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}