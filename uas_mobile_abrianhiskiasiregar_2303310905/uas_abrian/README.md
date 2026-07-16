# uas_mobile_abrianhiskiasiregar_2303310905

Aplikasi UAS Mobile Programming — Abrian Hiskia Siregar (2303310905).

## Cara menjalankan

1. Pastikan Flutter SDK sudah terpasang: `flutter --version`
2. Extract folder ini, lalu masuk ke direktorinya:
   ```
   cd uas_mobile_abrianhiskiasiregar_2303310905
   ```
3. Ambil dependencies:
   ```
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```
   flutter run
   ```

## Struktur halaman

- **Splash Screen** — tampil 3 detik sebelum masuk ke Home.
- **Home** — ringkasan info movies (unggulan, statistik, genre populer, rekomendasi).
- **Riwayat** — daftar film yang pernah dibuka/diklik, urut dari yang terbaru.
- **Movies** — daftar film horror dari API `https://api.sampleapis.com/movies/horror` (file `lib/screens/movies_list.dart`), lengkap dengan pencarian judul.
- **Pesan** — template kosong dengan placeholder "No. Message".
- **Profil** — identitas mahasiswa.

## Catatan

- Data movies diambil langsung dari API publik, butuh koneksi internet saat runtime.
- Riwayat disimpan sementara di memori aplikasi (akan reset saat aplikasi ditutup total).
