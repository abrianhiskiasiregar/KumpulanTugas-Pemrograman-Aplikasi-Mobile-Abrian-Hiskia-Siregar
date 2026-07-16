import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../utils/app_colors.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _service = MovieService();
  late Future<List<Movie>> _futureMovies;

  @override
  void initState() {
    super.initState();
    _futureMovies = _service.fetchMovies();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureMovies = _service.fetchMovies();
    });
    await _futureMovies;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: _refresh,
        child: FutureBuilder<List<Movie>>(
          future: _futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            }
            if (snapshot.hasError) {
              return _buildErrorState();
            }

            final movies = snapshot.data ?? [];
            final withPoster = movies.where((m) => m.posterUrl.isNotEmpty).toList();
            final featured = withPoster.isNotEmpty ? withPoster.first : (movies.isNotEmpty ? movies.first : null);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                if (featured != null) _buildFeaturedCard(featured),
                const SizedBox(height: 24),
                _buildStatsRow(movies.length, withPoster.length),
                const SizedBox(height: 24),
                _buildSectionTitle('Rekomendasi Untukmu'),
                const SizedBox(height: 12),
                _buildRecommendationList(withPoster.skip(1).take(12).toList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.waving_hand_rounded, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, Abrian', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              SizedBox(height: 2),
              Text(
                'Temukan film horror terbaik',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.notifications_none_rounded, color: AppColors.darkNavy),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Movie movie) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
      child: Container(
        height: 210,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.posterUrl.isNotEmpty
                ? Image.network(movie.posterUrl, fit: BoxFit.cover)
                : Container(color: AppColors.primaryBlue),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.accentLime,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'SEDANG TREN',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                    ),
                  ),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int totalMovies, int totalWithPoster) {
    return Row(
      children: [
        Expanded(child: _statCard(Icons.local_movies_rounded, '$totalMovies', 'Total Film')),
        const SizedBox(width: 14),
        Expanded(child: _statCard(Icons.image_rounded, '$totalWithPoster', 'Ada Poster')),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.softBlue, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.darkNavy)),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.darkNavy));
  }

  Widget _buildRecommendationList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Text('Belum ada rekomendasi tersedia', style: TextStyle(color: AppColors.textGrey, fontSize: 13));
    }
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: movie.posterUrl.isNotEmpty
                          ? Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imageFallback(),
                            )
                          : _imageFallback(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.darkNavy),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.softBlue,
      child: const Icon(Icons.movie_rounded, color: AppColors.primaryBlue, size: 34),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 46, color: AppColors.textGrey),
            const SizedBox(height: 12),
            const Text('Gagal memuat data movies', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkNavy)),
            const SizedBox(height: 6),
            const Text('Periksa koneksi internet kamu lalu tarik layar untuk mencoba lagi.',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentLime,
                foregroundColor: AppColors.darkNavy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
