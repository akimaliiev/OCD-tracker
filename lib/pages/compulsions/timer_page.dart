import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/pages/home_page.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<String> _compulsions = [];
  String? _selectedCompulsion;
  String? _selectedTime;
  bool _isTimerRunning = false;
  Duration _timerDuration = Duration.zero;
  Timer? _timer;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _fetchCompulsions();
  }

  /// Fetch compulsions from Firebase **every time the page is built**
  Future<void> _fetchCompulsions() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
      setState(() {
        _compulsions = List<String>.from(userDoc['compulsions'] ?? []);
      });
    }
  }

  /// Ensure Firebase data updates whenever page is opened
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCompulsions();
  }

  void _initializeNotifications() async {
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('potato'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _showNotification() async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'timer_channel',
        'Timer Notifications',
        channelDescription: 'Notifications when the timer ends',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      0,
      'Great job!',
      'You’re stronger than you think!',
      notificationDetails,
    );
  }

  void _startStopTimer() {
    if (_isTimerRunning) {
      setState(() {
        _isTimerRunning = false;
        _timer?.cancel();
        _timerDuration = Duration.zero;
      });
    } else if (_selectedTime != null) {
      int seconds = _parseTime(_selectedTime!);
      setState(() {
        _isTimerRunning = true;
        _timerDuration = Duration(seconds: seconds);
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDuration.inSeconds > 0) {
        setState(() {
          _timerDuration -= const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTimerRunning = false;
        });
        _showNotification();
      }
    });
  }

  int _parseTime(String time) {
    switch (time) {
      case '1 minute': return 60;
      case '2 minutes': return 120;
      case '5 minutes': return 300;
      case '10 minutes': return 600;
      case '15 minutes': return 900;
      case '20 minutes': return 1200;
      case '30 minutes': return 1800;
      case '45 minutes': return 2700;
      case '1 hour': return 3600;
      case '2 hours': return 7200;
      case '3 hours': return 10800;
      default: return 60;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delay Your Compulsion',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⏳ A little trick to manage your compulsions: delay them!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose which one you want to delay:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            _buildAdvancedDropdown(
              context,
              value: _selectedCompulsion,
              hint: "Choose",
              items: _compulsions, // Now it always fetches latest compulsions
              onSelected: (value) {
                setState(() {
                  _selectedCompulsion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Set the time period:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            _buildAdvancedDropdown(
              context,
              value: _selectedTime,
              hint: "Choose",
              items: const [
                '1 minute', '2 minutes', '5 minutes', '10 minutes', '15 minutes',
                '20 minutes', '30 minutes', '45 minutes', '1 hour', '2 hours', '3 hours'
              ],
              onSelected: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
            ),
            const SizedBox(height: 60),
            Center(
              child: Text(
                _formatDuration(_timerDuration),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
            ),
            const Spacer(),
            Center(
              child: MyButton(
                text: _isTimerRunning ? 'Stop' : 'Start',
                onTap: _startStopTimer,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedDropdown(
    BuildContext context, {
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 16, color: Colors.brown)),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.brown, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value ?? hint, style: const TextStyle(fontSize: 16, color: Colors.brown)),
            const Icon(Icons.arrow_drop_down, color: Colors.brown),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
