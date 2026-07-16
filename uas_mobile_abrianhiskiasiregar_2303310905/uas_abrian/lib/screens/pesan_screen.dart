import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PesanScreen extends StatelessWidget {
  const PesanScreen({super.key});

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
                  child: const Icon(Icons.chat_bubble_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pesan',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.darkNavy),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(color: AppColors.softBlue, shape: BoxShape.circle),
                        child: const Icon(Icons.person_outline_rounded, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('No. Message', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.darkNavy)),
                            SizedBox(height: 4),
                            Text('Belum ada pesan masuk', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      const Text('--:--', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
