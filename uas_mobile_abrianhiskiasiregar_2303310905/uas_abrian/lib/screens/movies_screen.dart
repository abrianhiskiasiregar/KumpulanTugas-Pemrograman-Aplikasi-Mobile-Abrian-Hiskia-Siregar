import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'movies_list.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.local_movies_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Movies Horror',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: MoviesList()),
        ],
      ),
    );
  }
}
