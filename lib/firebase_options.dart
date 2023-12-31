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
    apiKey: 'AIzaSyBelvxpUqBb8e8415W8fDmrs5WFLL8ezAk',
    appId: '1:714217030486:web:f2a7be4742feb666d5ccf7',
    messagingSenderId: '714217030486',
    projectId: 'restaurant-2b3d6',
    authDomain: 'restaurant-2b3d6.firebaseapp.com',
    storageBucket: 'restaurant-2b3d6.appspot.com',
    measurementId: 'G-9EK4MLS9W7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLJzVCtEP0D45I9PtDYyfQPDrT-LdVfl4',
    appId: '1:714217030486:android:3ffdafa3268988cfd5ccf7',
    messagingSenderId: '714217030486',
    projectId: 'restaurant-2b3d6',
    storageBucket: 'restaurant-2b3d6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0ap-vSBOsrkmsSkjwZkn1jJnGWmeXfpk',
    appId: '1:714217030486:ios:26978d12780ecb35d5ccf7',
    messagingSenderId: '714217030486',
    projectId: 'restaurant-2b3d6',
    storageBucket: 'restaurant-2b3d6.appspot.com',
    iosBundleId: 'com.universe.restaurant',
  );
}
