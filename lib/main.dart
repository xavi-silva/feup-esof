import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/control/notifications/notifications.dart';
import 'package:sweepspot/view/pages/auth/auth_page.dart';
import 'package:sweepspot/view/pages/auth/verify_email_page.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:flutter/services.dart';

Future main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Event Notifier',
        channelDescription:
            'Notification channel to notify all event-related matter',
        importance: NotificationImportance.High,
        channelShowBadge: true,
        defaultColor: Color(0xFFE1F7DB),
      ),
    ],
    debug: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyB7QtlpZnaoAgi-guaTek6ECouY9r5wY1Q',
      appId: '1:970450613662:android:10913ce98f60e55b3a128f',
      messagingSenderId: '970450613662',
      projectId: 'sweepspot-9afed',
      storageBucket: 'sweepspot-9afed.appspot.com',
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
    listenForEventChanges();
    scheduleInitialNotifications();
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static bool init = true;
  static final String title = 'Sweep Spot';

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightGreen,
            backgroundColor: Color(0xFFA5E4C6),
          ).copyWith(secondary: Color.fromARGB(255, 22, 144, 83)),
        ),
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && MyApp.init) {
              FirebaseAuth.instance.signOut();
              MyApp.init = false;
            }
            if (snapshot.hasData) {
              MyApp.init = false;
              return VerifyEmailPage(
                authController: AuthController(FirebaseAuth.instance),
              );
            } else {
              MyApp.init = false;
              return AuthPage();
            }
          },
        ),
      );
}

void listenForEventChanges() {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DataController dataController = DataController(
    uid: FirebaseAuth.instance.currentUser!.uid,
    firestore: FirebaseFirestore.instance,
  );

  db.collection("Event").snapshots().listen((event) {
    for (var change in event.docChanges) {
      var eventName = change.doc['name'];
      var eventImageUrl = change.doc['image'];
      switch (change.type) {
        case DocumentChangeType.added:
          break;
        case DocumentChangeType.modified:
          changeNotification(
              eventImageUrl, eventName, change.doc.id, dataController);
          break;
        case DocumentChangeType.removed:
          deleteNotification(
              eventImageUrl, eventName, change.doc.id, dataController);
          break;
      }
    }
  });
}

void scheduleInitialNotifications() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DataController dataController = DataController(
    uid: FirebaseAuth.instance.currentUser!.uid,
    firestore: FirebaseFirestore.instance,
  );

  var eventsSnapshot = await db.collection("Event").get();
  for (var doc in eventsSnapshot.docs) {
    await scheduleEventNotification(doc, doc.id, dataController);
  }
}
