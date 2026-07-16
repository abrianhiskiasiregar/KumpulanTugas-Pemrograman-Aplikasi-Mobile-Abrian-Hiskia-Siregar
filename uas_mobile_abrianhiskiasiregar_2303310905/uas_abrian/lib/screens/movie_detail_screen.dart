import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/history_manager.dart';
import '../utils/app_colors.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  // Hanya diisi true saat film dibuka dari halaman Movies, supaya riwayat
  // benar-benar berisi item yang diklik dari halaman Movies (bukan dari
  // halaman lain seperti Home atau saat membuka ulang dari Riwayat).
  final bool recordHistory;

  const MovieDetailScreen({
    super.key,
    required this.movie,
    this.recordHistory = false,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.recordHistory) {
      HistoryManager.instance.addToHistory(widget.movie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.darkNavy,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: movie.posterUrl.isNotEmpty
                  ? Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.deepBlue,
                        child: const Icon(Icons.movie_rounded, color: Colors.white54, size: 60),
                      ),
                    )
                  : Container(
                      color: AppColors.deepBlue,
                      child: const Icon(Icons.movie_rounded, color: Colors.white54, size: 60),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _tag(Icons.local_movies_rounded, 'Genre Horror'),
                      const SizedBox(width: 10),
                      _tag(Icons.confirmation_number_rounded, movie.imdbId),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Informasi', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkNavy)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow('ID Film', '${movie.id}'),
                        const Divider(height: 20),
                        _detailRow('IMDb ID', movie.imdbId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Data film ini diambil langsung dari API sampleapis.com (kategori horror).',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textGrey, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGrey))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.darkNavy)),
      ],
    );
  }

  Widget _tag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.softBlue, borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryBlue),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.darkNavy)),
        ],
      ),
    );
  }
}
