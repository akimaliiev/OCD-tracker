import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ocr_2/components/my_button.dart';
import 'package:ocr_2/services/notification_service.dart';

class TimerPage extends StatefulWidget {
  final List<String> compulsions;

  TimerPage({required this.compulsions});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
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
  }

  void _initializeNotifications() async {
    final bool? result = await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('potato');

    const DarwinInitializationSettings darwinInitSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notifications when the timer ends',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: darwinDetails);

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
    } else {
      if (_selectedTime != null) {
        int seconds = _parseTime(_selectedTime!);
        setState(() {
          _isTimerRunning = true;
          _timerDuration = Duration(seconds: seconds);
        });
        _startTimer();
      }
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
      case '1 minute':
        return 60;
      case '2 minutes':
        return 120;
      case '5 minutes':
        return 300;
      case '10 minutes':
        return 600;
      case '15 minutes':
        return 900;
      case '20 minutes':
        return 1200;
      case '30 minutes':
        return 1800;
      case '45 minutes':
        return 2700;
      case '1 hour':
        return 3600;
      case '2 hours':
        return 7200;
      case '3 hours':
        return 10800;
      default:
        return 60;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delay Your Compulsion',
          style: TextStyle(color: Colors.brown),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            // const Text(
            //   "Instead of acting on a compulsion immediately, try telling yourself:\n"
            //   '"I’ll do it, but not just yet."\n\n'
            //   "Set a timer for the duration you choose, and during that time, shift your focus to something else—take a few deep breaths, listen to your favorite song, or engage in a calming activity.\n\n"
            //   "This exercise helps create space between the urge and the action, giving your brain a chance to realize you don’t have to act on the compulsion.",
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.brown,
            //   ),
            // ),
            const Text(
              'Choose which one you want to delay:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCompulsion,
              hint: const Text("Choose"),
              items: widget.compulsions
                  .map((compulsion) => DropdownMenuItem<String>(
                        value: compulsion,
                        child: Text(compulsion),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCompulsion = value;
                });
              },
            ),
            const Text(
              'Set the time periodй:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),           
            DropdownButton<String>(
              value: _selectedTime,
              hint: const Text("Choose"),
              items: [
                '1 minute',
                '2 minutes',
                '5 minutes',
                '10 minutes',
                '15 minutes',
                '20 minutes',
                '30 minutes',
                '45 minutes',
                '1 hour',
                '2 hours',
                '3 hours'
              ].map((time) => DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
            ),
            const SizedBox(height: 60),
            Center(
              child: Text(
                _formatDuration(_timerDuration),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: MyButton(
                text: _isTimerRunning ? 'Stop' : 'Start',
                onTap: () {
                  //NotificationService().showNotification(title: 'Great job!', body: 'Timer is out.');
                  _startStopTimer();
                },
              ),
            ),
            const SizedBox(height: 40),
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
