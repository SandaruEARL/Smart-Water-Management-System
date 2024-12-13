import 'dart:async';
import 'package:aqua/pages/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsageOld extends StatefulWidget {
  const UsageOld({super.key});

  @override
  State<UsageOld> createState() => _UsageOldState();
}

class _UsageOldState extends State<UsageOld> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _usage = 0;
  bool _isLoading = false;
  Timer? _midnightTimer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadState();
    _loadUsageData();  // Load usage data for the selected day
    _scheduleMidnightTask();  // Set the midnight task
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedDayString = prefs.getString('selectedDay');
    if (selectedDayString != null) {
      setState(() {
        _selectedDay = DateTime.parse(selectedDayString);
        _focusedDay = _selectedDay!;
      });
    }
    setState(() {
      _calendarFormat = CalendarFormat.values[prefs.getInt('calendarFormat') ?? 0];
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedDay != null) {
      await prefs.setString('selectedDay', _selectedDay!.toIso8601String());
    }
    await prefs.setInt('calendarFormat', _calendarFormat.index);
  }

  Future<void> _loadUsageData() async {
    if (_selectedDay == null) return;

    final dateKey = _selectedDay!.toIso8601String().split('T')[0];

    setState(() {
      _isLoading = true;
    });

    // Fetch usage from Firestore
    try {
      DocumentSnapshot snapshot = await _firestore.collection('daily_usage').doc(dateKey).get();

      if (snapshot.exists) {
        setState(() {
          _usage = snapshot['liters'] ?? 0;  // Set usage if the field exists
        });
      } else {
        setState(() {
          _usage = 0;  // Default value if no document exists
        });
      }
    } catch (e) {
      print('Error fetching usage data from Firestore: $e');
      setState(() {
        _usage = 0;  // Default value in case of error
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUsageToFirestore() async {
    if (_selectedDay == null) return;

    final dateKey = _selectedDay!.toIso8601String().split('T')[0];
    final dayName = _getDayName(_selectedDay!);

    // Save the usage data to Firestore
    await _firestore.collection('daily_usage').doc(dateKey).set({
      'day': dayName,
      'liters': _usage,
    }, SetOptions(merge: true));  // Merge to update existing data if needed
  }

  Future<void> _fetchWaterUsageAndSave() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming that the "water" field is fetched from Firestore
      DocumentSnapshot waterData = await _firestore.collection('water').doc('current_usage').get();
      int waterUsage = waterData['water'] ?? 0;  // Get the "water" field value

      setState(() {
        _usage += waterUsage;  // Increment usage
      });

      await _saveUsageToFirestore();  // Save updated usage to Firestore
    } catch (e) {
      print('Error fetching water usage: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createDocumentForNextDay() async {
    DateTime nextDay = DateTime.now().add(const Duration(days: 1));
    String dateKey = nextDay.toIso8601String().split('T')[0];
    String dayName = _getDayName(nextDay);

    await _firestore.collection('daily_usage').doc(dateKey).set({
      'day': dayName,
      'liters': 0,
    });

    print('Document created for $dateKey with day name $dayName');
  }

  void _scheduleMidnightTask() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final durationUntilMidnight = nextMidnight.difference(now);

    print("Scheduling midnight task in ${durationUntilMidnight.inSeconds} seconds");

    _midnightTimer = Timer(durationUntilMidnight, () async {
      print("Executing midnight task");

      await _saveUsageToFirestore();  // Save usage to Firestore at midnight
      await _createDocumentForNextDay();  // Create a new document for the next day

      setState(() {
        _usage = 0;  // Reset usage for the new day
      });

      _scheduleMidnightTask();  // Reschedule the task for the next midnight
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _saveState();  // Save the selected day
    _loadUsageData();  // Load usage data for the selected day
  }

  String _getDayName(DateTime date) {
    return ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][date.weekday % 7];
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();  // Cancel the midnight task timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offAll(const MyNavigationBar());
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            color: Colors.white,
            height: 0,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.grey]),
          ),
        ),
        centerTitle: false,
        title: const Text(
          "Usage",
          style: TextStyle(fontFamily: "roboto", color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(3000, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                  _saveState();  // Save state when the format changes
                }
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ),
            if (_selectedDay != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.blue, // Blue line above
                      thickness: 2, // Adjust the thickness as needed
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Day: ${_getDayName(_selectedDay!)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "kinetika",
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                        : Text(
                      "Used: $_usage Liters",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: "kinetika",
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.blue, // Blue line below
                      thickness: 2, // Adjust the thickness as needed
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
