import 'package:aquarium_app/components/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databases = FirebaseDatabase.instance.ref();

  final DatabaseReference _ledControlRef =
      FirebaseDatabase.instance.ref('LEDControl');

  final DatabaseReference _fanStateRef =
      FirebaseDatabase.instance.ref('fans/fanState');
  final DatabaseReference _pump1StateRef =
      FirebaseDatabase.instance.ref('pumps/pump1');
  final DatabaseReference _pump2StateRef =
      FirebaseDatabase.instance.ref('pumps/pump2');
  final DatabaseReference _temperatureStateRef =
      FirebaseDatabase.instance.ref('sensors/temperature');
  final DatabaseReference _lastFeedStateRef =
      FirebaseDatabase.instance.ref('feeding/lastFeedingTime');
  String _fanContent = 'on';
  String _pump1Content = 'on';
  String _pump2Content = 'on';
  String _temperature = 'Loading...';
  String _lastFeed = '...';
  int selectedOption = -1;

  @override
  void initState() {
    super.initState();
    _fanStateRef.onValue.listen((event) {
      final int fanState = event.snapshot.value as int;
      setState(() {
        _fanContent = fanState == 1 ? 'on' : 'off';
      });
    });
    _pump1StateRef.onValue.listen((event) {
      final int pump1State = event.snapshot.value as int;
      setState(() {
        _pump1Content = pump1State == 1 ? 'on' : 'off';
      });
    });
    _pump2StateRef.onValue.listen((event) {
      final int pump2State = event.snapshot.value as int;
      setState(() {
        _pump2Content = pump2State == 1 ? 'on' : 'off';
      });
    });
    _temperatureStateRef.onValue.listen((event) {
      final double temperature = event.snapshot.value as double;
      setState(() {
        _temperature = '${temperature.toStringAsFixed(1)}°';
      });
    });
    _lastFeedStateRef.onValue.listen((event) {
      final String timestampString = event.snapshot.value as String;
      print(timestampString);
      DateTime dateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestampString);
      dateTime = dateTime.add(Duration(hours: 1)); // Increase the hour by 1
      final String formattedDate = DateFormat('HH:mm dd MMM').format(dateTime);
      setState(() {
        _lastFeed = formattedDate;
      });
    });
  }

  void _toggleFanState() async {
    try {
      final DataSnapshot snapshot = await _fanStateRef.get();
      final int currentState = snapshot.value as int;
      final int newState = currentState == 1 ? 0 : 1;
      await _fanStateRef.set(newState);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _togglePump1State() async {
    try {
      final DataSnapshot snapshot = await _pump1StateRef.get();
      final int currentState = snapshot.value as int;
      final int newState = currentState == 1 ? 0 : 1;
      await _pump1StateRef.set(newState);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _togglePump2State() async {
    try {
      final DataSnapshot snapshot = await _pump2StateRef.get();
      final int currentState = snapshot.value as int;
      final int newState = currentState == 1 ? 0 : 1;
      await _pump2StateRef.set(newState);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _sendServoCommand() async {
    try {
      await databases.child("test/servo").set(1);
      print("Servo command sent!");
      Future.delayed(Duration(seconds: 2), () async {
        await databases.child("test/servo").set(0);
      });
    } catch (e) {
      print("Failed to send servo command: $e");
    }
  }

  void _showLightingOptions(BuildContext context) async {
    // Fetch the current value from Firebase
    final DataSnapshot snapshot = await _ledControlRef.get();
    final int currentValue = snapshot.value as int;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          selectedOption = currentValue;
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'Select LED Color',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<int>(
                      title: Text(
                        'Red',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 1,
                      groupValue: selectedOption,
                      activeColor: Colors.red,
                      hoverColor: Colors.red,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text(
                        'Green',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 2,
                      groupValue: selectedOption,
                      activeColor: Colors.green,
                      hoverColor: Colors.green,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text(
                        'Blue',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 3,
                      groupValue: selectedOption,
                      activeColor: Colors.blue,
                      hoverColor: Colors.blue,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text(
                        'Rainbow',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 4,
                      groupValue: selectedOption,
                      activeColor: Colors.purple,
                      hoverColor: Colors.purple,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text(
                        'White',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 5,
                      groupValue: selectedOption,
                      activeColor: Colors.white,
                      hoverColor: Colors.white,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: Text(
                        'Off',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      value: 0,
                      groupValue: selectedOption,
                      activeColor: Colors.grey.shade700,
                      hoverColor: Colors.grey.shade700,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedOption != -1) {
                    _ledControlRef.set(selectedOption);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 450,
                  child: Image.asset(
                    "assets/background2.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.4),
                  width: double.infinity,
                  height: 450, // Darken filter
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          DigitalClock(
                            showSeconds: false,
                            isLive: true,
                            textScaleFactor: 3,
                            digitalClockTextColor: Colors.white,
                            padding: EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            datetime: DateTime.now(),
                          ),
                          Text(
                            "Temperature: $_temperature",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, -40), // Move the container up by 40 pixels
              child: Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      children: [
                        // Add your content here
                        Row(
                          children: [
                            Expanded(
                              child: CustomCard(
                                color: Colors.orange,
                                iconColor: Colors.orange.shade900,
                                icon: Icons.light_mode,
                                title: "Lighting",
                                content: "set",
                                onPressed: () {
                                  _showLightingOptions(context);
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: CustomCard(
                                color: Colors.blue,
                                iconColor: Colors.blue.shade900,
                                icon: Icons.wind_power,
                                title: "ESP Fan",
                                content: _fanContent,
                                onPressed: _toggleFanState,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        CustomCard(
                          color: Colors.green.shade300,
                          iconColor: Colors.green.shade600,
                          icon: Icons.bubble_chart,
                          title: "Terakhir diberi: $_lastFeed",
                          content: "Beri Makan",
                          width: double.infinity,
                          onPressed: _sendServoCommand,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomCard(
                                color: Colors.pink.shade300,
                                iconColor: Colors.pink.shade700,
                                icon: Icons.fire_hydrant_alt,
                                title: "Pompa 1",
                                content: _pump1Content,
                                onPressed: _togglePump1State,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: CustomCard(
                                color: Colors.purple.shade300,
                                iconColor: Colors.purple.shade700,
                                icon: Icons.fire_hydrant_alt,
                                title: "Pompa 2",
                                content: _pump2Content,
                                onPressed: _togglePump2State,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
