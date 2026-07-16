class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String imdbId;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.imdbId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final rawPoster = json['posterURL']?.toString().trim() ?? '';
    final looksLikeImage = rawPoster.startsWith('http') &&
        (rawPoster.contains('.jpg') || rawPoster.contains('.jpeg') || rawPoster.contains('.png'));

    return Movie(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString().trim().isNotEmpty == true ? json['title'].toString() : 'Tanpa Judul',
      // Beberapa data dari API bernilai "N/A" atau link non-gambar (mis. Pinterest),
      // jadi hanya URL yang benar-benar mengarah ke file gambar yang dipakai.
      posterUrl: looksLikeImage ? rawPoster : '',
      imdbId: json['imdbId']?.toString() ?? '-',
    );
  }
}
