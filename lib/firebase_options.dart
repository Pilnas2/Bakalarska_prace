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
    apiKey: 'AIzaSyBSl_Ql_-SmdZvRW2Nj5_NYe2rSpDa9GWo',
    appId: '1:559556940793:web:42c0b39b4adf56a91aa328',
    messagingSenderId: '559556940793',
    projectId: 'bakalarska-prace-pilny',
    authDomain: 'bakalarska-prace-pilny.firebaseapp.com',
    storageBucket: 'bakalarska-prace-pilny.firebasestorage.app',
    measurementId: 'G-GTC01BNMNF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8QBWPXpyT9BlRxcAymnuzAY6CNwQ62kE',
    appId: '1:559556940793:android:efe00ccc47b75ab41aa328',
    messagingSenderId: '559556940793',
    projectId: 'bakalarska-prace-pilny',
    storageBucket: 'bakalarska-prace-pilny.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAeLbEHfW91fXXFBZluMM6GLNvMftphY_A',
    appId: '1:559556940793:ios:da8118099572733a1aa328',
    messagingSenderId: '559556940793',
    projectId: 'bakalarska-prace-pilny',
    storageBucket: 'bakalarska-prace-pilny.firebasestorage.app',
    iosBundleId: 'com.example.bakalarskaPracePilny',
  );
}
