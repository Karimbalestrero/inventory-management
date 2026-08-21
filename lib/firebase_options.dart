import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDK0difFHaoQbmkWoBNtXz39_cV8nQAg8',
    appId: '1:667154777425:web:fa8ec02d4118c0dcd9bf70',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    authDomain: 'inventory-management-30344.firebaseapp.com',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PUT_ANDROID_API_KEY_HERE',
    appId: 'PUT_ANDROID_APP_ID_HERE',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'PUT_IOS_API_KEY_HERE',
    appId: 'PUT_IOS_APP_ID_HERE',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
    iosBundleId: 'com.example.inventoryManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'PUT_MACOS_API_KEY_HERE',
    appId: 'PUT_MACOS_APP_ID_HERE',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
    iosBundleId: 'com.example.inventoryManagement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'PUT_WINDOWS_API_KEY_HERE',
    appId: 'PUT_WINDOWS_APP_ID_HERE',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'PUT_LINUX_API_KEY_HERE',
    appId: 'PUT_LINUX_APP_ID_HERE',
    messagingSenderId: '667154777425',
    projectId: 'inventory-management-30344',
    storageBucket: 'inventory-management-30344.firebasestorage.app',
  );
}
