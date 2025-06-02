
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // create instance of FB messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialise notifications
  Future<void> initNotification() async {
    // request permission from user (will import user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token (normally we should send it to your backend server)
    print('Token: $fCMToken');
  }

  // function to handle received messages

  // function to initialise foreground and background settings
}