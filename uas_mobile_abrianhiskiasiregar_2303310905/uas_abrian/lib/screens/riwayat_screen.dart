import 'package:flutter/material.dart';
import '../services/history_manager.dart';
import '../utils/app_colors.dart';
import 'movie_detail_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final HistoryManager _historyManager = HistoryManager.instance;

  @override
  void initState() {
    super.initState();
    _historyManager.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    _historyManager.removeListener(_onHistoryChanged);
    super.dispose();
  }

  void _onHistoryChanged() {
    if (mounted) setState(() {});
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final entries = _historyManager.entries;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.softBlue, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.history_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Riwayat Tontonan',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                  ),
                ),
                if (entries.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      _historyManager.clearHistory();
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                  ),
              ],
            ),
          ),
          Expanded(
            child: entries.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: entry.movie)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: entry.movie.posterUrl.isNotEmpty
                                      ? Image.network(
                                          entry.movie.posterUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: AppColors.softBlue,
                                            child: const Icon(Icons.movie_rounded, color: AppColors.primaryBlue),
                                          ),
                                        )
                                      : Container(
                                          color: AppColors.softBlue,
                                          child: const Icon(Icons.movie_rounded, color: AppColors.primaryBlue),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.darkNavy),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Dilihat pukul ${_formatTime(entry.viewedAt)}',
                                        style: const TextStyle(fontSize: 11.5, color: AppColors.textGrey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.softBlue, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.history_rounded, size: 44, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 16),
            const Text('Belum ada riwayat', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkNavy)),
            const SizedBox(height: 6),
            const Text(
              'Film yang kamu buka di halaman Movies\nakan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}
