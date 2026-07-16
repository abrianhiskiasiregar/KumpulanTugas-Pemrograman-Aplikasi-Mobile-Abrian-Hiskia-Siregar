import 'package:flutter/material.dart';
import 'controllers/dashboard_controller.dart';
import 'models/stock_model.dart';
import 'models/notification_model.dart';
import 'models/log_model.dart';
import 'widgets/stock_card.dart';
import 'widgets/notification_display.dart';
import 'widgets/log_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Realtime Dashboard",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = DashboardController();

  StockModel? stock1;
  StockModel? stock2;
  NotificationModel? notif;
  List<LogModel> logs = [];

  @override
  void initState() {
    super.initState();
    controller.initialize();

    // STREAM SAHAM (broadcast)
    controller.stockStream.listen((data) {
      setState(() {
        if (data.symbol == "BBCA") {
          stock1 = data;
        } else if (data.symbol == "BBRI") {
          stock2 = data;
        }
      });
    });

    // STREAM NOTIF
    controller.notificationStream.listen((data) {
      setState(() => notif = data);
    });

    // STREAM LOG
    controller.logStream.listen((data) {
      setState(() {
        logs.insert(0, data);
        if (logs.length > 20) logs.removeLast();
      });
    }, onError: (error) {
      setState(() {
        logs.insert(0, LogModel.error("System Error: $error"));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Real-time Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: controller.toggleError,
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: controller.sendTestError,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= SAHAM =================
            const Text(
              "📈 Harga Saham (Broadcast Stream)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Dua widget ini mendengarkan STREAM YANG SAMA",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: stock1 != null
                      ? StockCard(stock: stock1!, title: "Widget 1")
                      : _loadingCard(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: stock2 != null
                      ? StockCard(stock: stock2!, title: "Widget 2")
                      : _loadingCard(),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= NOTIF =================
            const Text(
              "🔔 Notifikasi (Single-subscription)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            NotificationDisplay(notification: notif),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.sendNotification(
                          "User membuka dashboard",
                          NotificationType.info);
                    },
                    child: const Text("Info"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      controller.sendNotification(
                          "Memory tinggi",
                          NotificationType.warning);
                    },
                    child: const Text("Warning"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      controller.sendNotification(
                          "Koneksi terputus",
                          NotificationType.error);
                    },
                    child: const Text("Error"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= LOG =================
            const Text(
              "📋 Log Aktivitas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: LogList(logs: logs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("Menunggu data...")),
      ),
    );
  }
}