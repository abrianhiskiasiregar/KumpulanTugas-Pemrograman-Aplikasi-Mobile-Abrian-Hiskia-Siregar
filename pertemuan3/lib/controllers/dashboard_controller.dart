import 'dart:async';
import '../models/stock_model.dart';
import '../models/notification_model.dart';
import '../models/log_model.dart';

class DashboardController {
  static final DashboardController _instance =
      DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  late final StreamController<StockModel> _stockController;
  Stream<StockModel> get stockStream => _stockController.stream;

  late final StreamController<NotificationModel> _notificationController;
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;

  late final StreamController<LogModel> _logController;
  Stream<LogModel> get logStream => _logController.stream;

  Timer? _timer;
  bool _simulateError = false;

  void initialize() {
    _stockController = StreamController<StockModel>.broadcast();
    _notificationController = StreamController<NotificationModel>();
    _logController = StreamController<LogModel>();

    _startStock();
  }

  void _startStock() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_simulateError && DateTime.now().second % 5 == 0) {
        _stockController.addError("Error ambil saham");
        _logController.add(LogModel.error("Stock error"));
        return;
      }

      final stock = StockModel.random("BBCA");
      _stockController.add(stock);
      _logController.add(LogModel.info("Update: ${stock.symbol}"));
    });
  }

  void sendNotification(String msg, NotificationType type) {
    NotificationModel notif;

    switch (type) {
      case NotificationType.info:
        notif = NotificationModel.info(msg);
        break;
      case NotificationType.warning:
        notif = NotificationModel.warning(msg);
        break;
      case NotificationType.error:
        notif = NotificationModel.error(msg);
        break;
    }

    _notificationController.add(notif);
  }

  void toggleError() {
    _simulateError = !_simulateError;
  }

  void dispose() {
    _timer?.cancel();
    _stockController.close();
    _notificationController.close();
    _logController.close();
  }

  void sendTestError() {
  _logController.addError("Test error dari user!");
  }
}