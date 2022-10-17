// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCjH8g4cTLOztPFcfIdImlUbUbMt-TpfEk',
    appId: '1:297782769824:web:1401326d175d1de73471c5',
    messagingSenderId: '297782769824',
    projectId: 'orderaholic-f387d',
    authDomain: 'orderaholic-f387d.firebaseapp.com',
    storageBucket: 'orderaholic-f387d.appspot.com',
    measurementId: 'G-MYH5X4MXR8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4BRYqcw6rpf5Alr_60Wc9ea_mAX6EDic',
    appId: '1:297782769824:android:5c34947d073533343471c5',
    messagingSenderId: '297782769824',
    projectId: 'orderaholic-f387d',
    storageBucket: 'orderaholic-f387d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGrS1SwpNOwSbWYn9XNDfJCDaJW11TemI',
    appId: '1:297782769824:ios:f95f74b3a6e5238b3471c5',
    messagingSenderId: '297782769824',
    projectId: 'orderaholic-f387d',
    storageBucket: 'orderaholic-f387d.appspot.com',
    iosClientId: '297782769824-43bv0h1havfosmj7ir2ee2vl6keqsq2o.apps.googleusercontent.com',
    iosBundleId: 'com.example.mufypOrderaholic2cClient',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBGrS1SwpNOwSbWYn9XNDfJCDaJW11TemI',
    appId: '1:297782769824:ios:f95f74b3a6e5238b3471c5',
    messagingSenderId: '297782769824',
    projectId: 'orderaholic-f387d',
    storageBucket: 'orderaholic-f387d.appspot.com',
    iosClientId: '297782769824-43bv0h1havfosmj7ir2ee2vl6keqsq2o.apps.googleusercontent.com',
    iosBundleId: 'com.example.mufypOrderaholic2cClient',
  );
}
