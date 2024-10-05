import 'package:flutter/material.dart';
import 'dart:async';

class Pewaktu extends StatefulWidget {
  @override
  _PewaktuState createState() => _PewaktuState();
}

class _PewaktuState extends State<Pewaktu> {
  int _totalMilliseconds = 0; 
  Timer? _timer;
  bool _isRunning = false;

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  void _startTimer() {
    if (_totalMilliseconds > 0) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (_totalMilliseconds <= 0) {
          _stopTimer();
        } else {
          setState(() {
            _totalMilliseconds -= 10; 
          });
        }
      });
    }
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _totalMilliseconds = 0; 
      _hoursController.clear();
      _minutesController.clear();
      _secondsController.clear();
    });
  }

  String _formatTime() {
    final hours = (_totalMilliseconds ~/ 3600000) % 24;
    final minutes = (_totalMilliseconds ~/ 60000) % 60;
    final seconds = (_totalMilliseconds ~/ 1000) % 60;
    final formattedMilliseconds = (_totalMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$formattedMilliseconds';
  }

  void _setTimer() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    setState(() {
      _totalMilliseconds = (hours * 3600 + minutes * 60 + seconds) * 1000; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('Pewaktu'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220, 
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.2),
                    border: Border.all(color: Colors.deepPurple, width: 8),
                  ),
                ),
                // Timer Text
                Text(
                  _formatTime(),
                  style: TextStyle(
                    fontSize: 36, // Ukuran font diperkecil
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: _isRunning && _totalMilliseconds > 0
                        ? _totalMilliseconds / ((int.tryParse(_hoursController.text) ?? 0) * 3600 +
                          (int.tryParse(_minutesController.text) ?? 0) * 60 +
                          (int.tryParse(_secondsController.text) ?? 0)) * 1000
                        : 0,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeInputField(_hoursController, 'Jam'),
                _buildTimeInputField(_minutesController, 'Menit'),
                _buildTimeInputField(_secondsController, 'Detik'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.timer, 'Set Timer', _setTimer, !_isRunning),
                _buildActionButton(Icons.play_arrow, 'Start', _startTimer, !_isRunning && _totalMilliseconds > 0),
                _buildActionButton(Icons.pause, 'Stop', _stopTimer, _isRunning),
                _buildActionButton(Icons.refresh, 'Reset', _resetTimer, !_isRunning && _totalMilliseconds > 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(TextEditingController controller, String label) {
    return Container(
      width: 80,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.deepPurple[50],
            labelStyle: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onPressed, bool enabled) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        primary: enabled ? Colors.deepPurple : Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
