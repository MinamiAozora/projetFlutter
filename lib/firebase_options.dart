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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBsTtEmoDKkKicLvqQ55EWBfTKvmrGcuZE',
    appId: '1:459519364638:web:37fc50a4b1755fe3d1680f',
    messagingSenderId: '459519364638',
    projectId: 'minamisora-3il-flutter-project',
    authDomain: 'minamisora-3il-flutter-project.firebaseapp.com',
    storageBucket: 'minamisora-3il-flutter-project.firebasestorage.app',
    measurementId: 'G-99N8QJH81L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXXmXqWR3qhDsT7zt4WEM26GtxoOHXzWI',
    appId: '1:459519364638:android:48366c28e71eeee5d1680f',
    messagingSenderId: '459519364638',
    projectId: 'minamisora-3il-flutter-project',
    storageBucket: 'minamisora-3il-flutter-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9cipwIzCZBfwKtx7VZ_IBnobfhu7dpP4',
    appId: '1:459519364638:ios:568fe7de2c8685fad1680f',
    messagingSenderId: '459519364638',
    projectId: 'minamisora-3il-flutter-project',
    storageBucket: 'minamisora-3il-flutter-project.firebasestorage.app',
    iosBundleId: 'com.example.tp1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9cipwIzCZBfwKtx7VZ_IBnobfhu7dpP4',
    appId: '1:459519364638:ios:568fe7de2c8685fad1680f',
    messagingSenderId: '459519364638',
    projectId: 'minamisora-3il-flutter-project',
    storageBucket: 'minamisora-3il-flutter-project.firebasestorage.app',
    iosBundleId: 'com.example.tp1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsTtEmoDKkKicLvqQ55EWBfTKvmrGcuZE',
    appId: '1:459519364638:web:8b0904041b1bec6dd1680f',
    messagingSenderId: '459519364638',
    projectId: 'minamisora-3il-flutter-project',
    authDomain: 'minamisora-3il-flutter-project.firebaseapp.com',
    storageBucket: 'minamisora-3il-flutter-project.firebasestorage.app',
    measurementId: 'G-4G15V5ZJQ2',
  );
}
