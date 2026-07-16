import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../utils/app_colors.dart';
import 'movie_detail_screen.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({super.key});

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  final MovieService _service = MovieService();
  late Future<List<Movie>> _futureMovies;
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _keyword = value.toLowerCase()),
              decoration: const InputDecoration(
                hintText: 'Cari judul film horror...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textGrey),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.textGrey, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        Expanded(
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
                  return ListView(
                    children: [
                      const SizedBox(height: 80),
                      const Icon(Icons.wifi_off_rounded, size: 44, color: AppColors.textGrey),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text('Gagal mengambil data dari API', style: TextStyle(color: AppColors.textGrey)),
                      ),
                    ],
                  );
                }

                var movies = snapshot.data ?? [];
                if (_keyword.isNotEmpty) {
                  movies = movies.where((m) => m.title.toLowerCase().contains(_keyword)).toList();
                }

                if (movies.isEmpty) {
                  return ListView(
                    children: const [
                      SizedBox(height: 80),
                      Center(child: Text('Film tidak ditemukan', style: TextStyle(color: AppColors.textGrey))),
                    ],
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _MovieCard(movie: movie);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie, recordHistory: true)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  width: double.infinity,
                  child: movie.posterUrl.isNotEmpty
                      ? Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: AppColors.softBlue,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => _fallback(),
                        )
                      : _fallback(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, color: AppColors.darkNavy),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number_rounded, size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          movie.imdbId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textGrey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.softBlue,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_rounded, color: AppColors.primaryBlue, size: 30),
    );
  }
}
