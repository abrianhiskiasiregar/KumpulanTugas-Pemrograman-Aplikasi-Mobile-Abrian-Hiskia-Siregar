import 'package:flutter/material.dart';
import 'dart:async';
class StopWatchPage extends StatefulWidget {
  const StopWatchPage({super.key});

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  late StreamController<int> _streamController;
  late Stream<int> _stopwatchStream;

  int _counter = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<int>();
    _stopwatchStream = _streamController.stream;
  }

  // Start
  void _start() {
    if (_isRunning) return;

    _isRunning = true;

    Future.doWhile(() async {
      if (!_isRunning) return false;

      await Future.delayed(const Duration(seconds: 1));

      if (_streamController.isClosed) return false;

      _counter++;
      _streamController.add(_counter);

      return true;
    });
  }

  // Stop
  void _stop() {
    setState(() {
      _isRunning = false;
    });
  }

  // Reset
  void _reset() {
    _stop();
    setState(() {
      _counter = 0;
    });

    if (!_streamController.isClosed) {
      _streamController.add(_counter);
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Stream: Stopwatch')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopwatchStream,
              initialData: 0,
              builder: (context, snapshot) {
                int currentValue = snapshot.data ?? 0;
                return Text(
                  '$currentValue detik',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _start,
                  child: const Text('Mulai'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _stop : null,
                  child: const Text('Hentikan'),
                ),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}