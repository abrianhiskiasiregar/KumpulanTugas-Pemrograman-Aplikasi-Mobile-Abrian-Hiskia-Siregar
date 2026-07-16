import 'package:flutter/material.dart';
import 'models/weather_message.dart';
import 'services/weather_stream_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/loading_widget.dart';
import 'widgets/empty_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Wheater Stream Abrian',

      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Run the app and edit the seedColor
        // below to see the theme update automatically.
        //
        // Flutter supports hot reload so changes can
        // appear instantly without restarting the app.
        //
        // This helps developers build interfaces faster
        // and makes UI testing easier during development.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),

        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,

      home: const MyHomePage(title: 'Realtime Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of the application.
  // It is stateful because the data displayed inside
  // the screen can change in realtime.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  late WeatherStreamService _weatherService;

  @override
  void initState() {
    super.initState();

    _weatherService = WeatherStreamService();

    _weatherService.startAutoWeather();
  }

  void _sendWeatherMessage() {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    _weatherService.addCustomWeather(_controller.text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // The build method reruns whenever the stream
    // sends new realtime weather data to the UI.

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        // TRY THIS: Change the AppBar color below
        // and use hot reload to instantly see changes.
        backgroundColor: Colors.black87,

        title: Text(
          widget.title,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),

            child: Center(
              child: Text(
                'Live Stream',

                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(16),

              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Tambahkan Informasi Cuaca',

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,

                        decoration: InputDecoration(
                          hintText: 'Contoh: Medan sedang hujan',

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          prefixIcon: const Icon(Icons.cloud),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton.icon(
                      onPressed: _sendWeatherMessage,

                      icon: const Icon(Icons.send),

                      label: const Text('Kirim'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Row(
              children: [
                Icon(Icons.autorenew, color: Colors.blueGrey[700]),

                const SizedBox(width: 8),

                Text(
                  'Data cuaca diperbarui otomatis setiap 5 detik',

                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<List<WeatherMessage>>(
              stream: _weatherService.weatherStream,

              builder: (context, snapshot) {
                // StreamBuilder listens to realtime
                // updates from the weather service.

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Terjadi kesalahan saat memuat data'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const EmptyState();
                }

                final weatherData = snapshot.data!;

                return ListView.builder(
                  itemCount: weatherData.length,

                  itemBuilder: (context, index) {
                    return WeatherCard(weather: weatherData[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        // Pressing this button also sends
        // data into the realtime stream.
        backgroundColor: Colors.black87,

        onPressed: _sendWeatherMessage,

        tooltip: 'Kirim Data',

        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    _weatherService.dispose();

    super.dispose();
  }
}
