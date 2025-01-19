import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SmartAquariumApp());
}

final FirebaseDatabase database = FirebaseDatabase.instance;
final DatabaseReference databases = FirebaseDatabase.instance.ref();

class SmartAquariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmartAquariumScreen(),
    );
  }
}

class SmartAquariumScreen extends StatefulWidget {
  @override
  _SmartAquariumScreenState createState() => _SmartAquariumScreenState();
}

class _SmartAquariumScreenState extends State<SmartAquariumScreen> {
  final DatabaseReference temperatureRef =
      FirebaseDatabase.instance.ref("sensors/temperature");
  double? currentTemperature;

  @override
  void initState() {
    super.initState();

    // Listener untuk membaca data suhu dari Firebase
    temperatureRef.onValue.listen((event) {
      final double? temperature = event.snapshot.value != null
          ? double.tryParse(event.snapshot.value.toString())
          : null;

      setState(() {
        currentTemperature = temperature;
      });
    });
  }

  Future<void> sendServoCommand() async {
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

  Future<void> sendPumpCommand(bool isOn) async {
    try {
      await databases.child("pumps/pump1").set(isOn ? 1 : 0);
      print("Pump ${isOn ? "ON" : "OFF"} command sent!");
    } catch (e) {
      print("Failed to send pump command: $e");
    }
  }

  Future<void> controlLED(int colorCode) async {
    try {
      await databases.child("LEDControl").set(colorCode);
      print("LED color set to: $colorCode");
    } catch (e) {
      print("Failed to set LED color: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3DFF6), Color(0xFFD6D0F2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Good morning!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "06.45 am",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 24),

              // Bagian Temperatur Aquarium
              TemperatureCard(currentTemperature: currentTemperature),
              SizedBox(height: 24),

              // Bagian Tombol (Servo dan Lampu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoomCard(
                    icon: Icons.pets,
                    label: "Beri Pakan",
                    onPressed: sendServoCommand,
                  ),
                  RoomCard(
                    icon: Icons.lightbulb,
                    label: "Kontrol Lampu",
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Pilih Kontrol Lampu"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controlLED(1); // Merah
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Merah"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controlLED(2); // Hijau
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Hijau"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controlLED(3); // Biru
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Biru"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controlLED(4); // Matikan LED
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("rainbow"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controlLED(0); // Matikan LED
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Matikan"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  RoomCard(
                    icon: Icons.water_damage,
                    label: "Pump ON",
                    onPressed: () => sendPumpCommand(true),
                  ),
                  RoomCard(
                    icon: Icons.water_damage,
                    label: "Pump OFF",
                    onPressed: () => sendPumpCommand(false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  RoomCard({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.purpleAccent,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureCard extends StatelessWidget {
  final double? currentTemperature;

  TemperatureCard({required this.currentTemperature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Temperatur Aquarium",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Text(
            currentTemperature != null
                ? "${currentTemperature!.toStringAsFixed(1)}°C"
                : "Loading...",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}
