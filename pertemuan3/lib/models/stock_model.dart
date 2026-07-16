class StockModel {
  final String symbol;
  final double price;
  final double change;
  final DateTime timestamp;

  StockModel({
    required this.symbol,
    required this.price,
    required this.change,
    required this.timestamp,
  });

  factory StockModel.random(String symbol) {
    return StockModel(
      symbol: symbol,
      price: 1000 + (DateTime.now().millisecond % 1000).toDouble(),
      change: (DateTime.now().millisecond % 20 - 10).toDouble(),
      timestamp: DateTime.now(),
    );
  }
}