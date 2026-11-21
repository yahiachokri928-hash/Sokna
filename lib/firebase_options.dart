import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
    apiKey: 'AIzaSyCpKOqE1HMah7kWD-ZNaEi6dfB6sHwibR0',
    appId: '1:14223692440:web:68de782968dcac733136ed',
    messagingSenderId: '14223692440',
    projectId: 'sokna-cloud-app',
    authDomain: 'sokna-cloud-app.firebaseapp.com',
    storageBucket: 'sokna-cloud-app.firebasestorage.app',
    measurementId: 'G-ZTC64XNW76',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoIRSCR2RGAd1Bxr_-QZ1PmC79zmwpgpY',
    appId: '1:14223692440:android:89db263bb61e8dd33136ed',
    messagingSenderId: '14223692440',
    projectId: 'sokna-cloud-app',
    storageBucket: 'sokna-cloud-app.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyFakeKeyForSoknaIosDemoPlaceholder',
    appId: '1:100000000000:ios:soknaiosplaceholder',
    messagingSenderId: '100000000000',
    projectId: 'sokna-isetbizerte',
    storageBucket: 'sokna-isetbizerte.appspot.com',
    iosBundleId: 'tn.isetbizerte.sokna',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyFakeKeyForSoknaMacosDemoPlaceholder',
    appId: '1:100000000000:ios:soknamacosplaceholder',
    messagingSenderId: '100000000000',
    projectId: 'sokna-isetbizerte',
    storageBucket: 'sokna-isetbizerte.appspot.com',
    iosBundleId: 'tn.isetbizerte.sokna',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyFakeKeyForSoknaWindowsDemoPlaceholder',
    appId: '1:100000000000:web:soknawindowsholder',
    messagingSenderId: '100000000000',
    projectId: 'sokna-isetbizerte',
    authDomain: 'sokna-isetbizerte.firebaseapp.com',
    storageBucket: 'sokna-isetbizerte.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyFakeKeyForSoknaLinuxDemoPlaceholder',
    appId: '1:100000000000:web:soknalinuxholder',
    messagingSenderId: '100000000000',
    projectId: 'sokna-isetbizerte',
    authDomain: 'sokna-isetbizerte.firebaseapp.com',
    storageBucket: 'sokna-isetbizerte.appspot.com',
  );
}
