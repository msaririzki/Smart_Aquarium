// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDu1gK0jAJ7c9gWCGg6wLmnXXrMsBvc1ys',
    appId: '1:612535964605:web:ab9ea8bacc2ca462a0b8d4',
    messagingSenderId: '612535964605',
    projectId: 'aquarium-78a85',
    authDomain: 'aquarium-78a85.firebaseapp.com',
    databaseURL: 'https://aquarium-78a85-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aquarium-78a85.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3HX6DfXeZvUTV8VFrfKzK_bcYtpfeUM4',
    appId: '1:612535964605:android:8c2a5a984829c08da0b8d4',
    messagingSenderId: '612535964605',
    projectId: 'aquarium-78a85',
    databaseURL: 'https://aquarium-78a85-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'aquarium-78a85.firebasestorage.app',
  );

}