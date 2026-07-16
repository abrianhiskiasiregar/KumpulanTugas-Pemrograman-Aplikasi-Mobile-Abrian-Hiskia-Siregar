import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/barang.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  final _kodeController =
      TextEditingController();

  final _namaController =
      TextEditingController();

  final _satuanController =
      TextEditingController();

  final _hargaController =
      TextEditingController();

  final _keteranganController =
      TextEditingController();

  List<Barang> listBarang = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final data =
        await DatabaseHelper.instance.getBarang();

    setState(() {
      listBarang =
          data.map((e) => Barang.fromMap(e)).toList();
    });
  }

  Future tambahData() async {
    final barang = Barang(
      kodeBarang: _kodeController.text,
      namaBarang: _namaController.text,
      satuan: _satuanController.text,
      harga: int.parse(
        _hargaController.text,
      ),
      keterangan:
          _keteranganController.text,
    );

    await DatabaseHelper.instance
        .insertBarang(barang.toMap());

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
      appBar: AppBar(
        title: const Text(
          "Data Barang",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  _kodeController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Kode Barang",
              ),
            ),

            TextField(
              controller:
                  _namaController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nama Barang",
              ),
            ),

            TextField(
              controller:
                  _satuanController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Satuan",
              ),
            ),

            TextField(
              controller:
                  _hargaController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Harga",
              ),
            ),

            TextField(
              controller:
                  _keteranganController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Keterangan",
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed:
                  tambahData,
              child:
                  const Text("Simpan"),
            ),

            const Divider(),

            Expanded(
              child:
                  ListView.builder(
                itemCount:
                    listBarang.length,
                itemBuilder:
                    (context,
                        index) {
                  final item =
                      listBarang[
                          index];

                  return ListTile(
                    title: Text(
                      item.namaBarang,
                    ),
                    subtitle:
                        Text(
                      "Kode: ${item.kodeBarang} | Harga: ${item.harga}",
                    ),
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