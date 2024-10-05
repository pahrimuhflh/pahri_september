import 'package:flutter/material.dart';
import 'dart:async';
import 'Pewaktu.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _elapsedTime = 0; 
  Timer? _timer;
  bool _isRunning = false;
  List<String> _laps = [];

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _elapsedTime += 10;
        });
      });
    }
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _elapsedTime = 0; 
      _laps.clear();
    });
  }

  void _addLap() {
    setState(() {
      _laps.add(_formatTime(_elapsedTime)); 
    });
  }

  String _formatTime(int totalMilliseconds) {
    final seconds = (totalMilliseconds ~/ 1000) % 60;
    final minutes = (totalMilliseconds ~/ 60000) % 60;
    final hours = totalMilliseconds ~/ 3600000;
    final formattedMilliseconds = (totalMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$formattedMilliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50], 
      appBar: AppBar(
        title: Text('Stopwatch'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _formatTime(_elapsedTime),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.play_arrow, 'Start', _isRunning ? null : _startTimer),
                _buildActionButton(Icons.pause, 'Stop', _isRunning ? _stopTimer : null),
                _buildActionButton(Icons.flag, 'Lap', _isRunning ? _addLap : null),
                _buildActionButton(Icons.refresh, 'Reset', _resetTimer),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pewaktu()),
                );
              },
              child: Text('Go to Timer'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              height: 200,
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Lap ${index + 1}: ${_laps[index]}',
                      style: TextStyle(fontSize: 18),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5), 
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildActionButton(IconData icon, String label, VoidCallback? onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
