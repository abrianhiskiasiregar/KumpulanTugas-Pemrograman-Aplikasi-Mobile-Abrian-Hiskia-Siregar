import 'package:flutter/material.dart';
import '../models/stock_model.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;
  final String title; // WAJIB ADA

  const StockCard({
    super.key,
    required this.stock,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Color color = stock.change >= 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(stock.symbol),
            Text(
              "Rp ${stock.price.toStringAsFixed(0)}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
            Text(
              "${stock.change.toStringAsFixed(1)}%",
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}