import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class FirebaseTest extends StatelessWidget {
  const FirebaseTest({super.key});

  // Function to send a command to Firebase
  Future<void> sendCommandToFirebase() async {
    DatabaseReference ref = database.ref("/command");
    try {
      await ref.set("FEED"); // Sending "FEED" command to ESP32
      print("Command sent to Firebase!");
    } catch (e) {
      print("Error sending command: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESP32 Firebase Test"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendCommandToFirebase, // Call the function when pressed
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Button color
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: TextStyle(fontSize: 20),
          ),
          child: Text('Send Feed Command'),
        ),
      ),
    );
  }
}
