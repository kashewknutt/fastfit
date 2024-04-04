import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  runApp(MyApp()); // Run your Flutter app
}

class MyApp extends StatelessWidget {
  // Initialize Firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCVzHlAD45jS83Ulbp8Dd-oZCrwMII_ZkE',
      appId: '1:22883390478:android:9add198f25f4ac5f52d85f',
      messagingSenderId: '22883390478',
      projectId: 'vesit-fastfit',
      storageBucket: 'vesit-fastfit.appspot.com',
    )
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Firebase initialization is in progress, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print('Error is: ${snapshot.error}');// If initialization fails, show an error message
            return Center(
              child: Text('Error initializing Firebase'),
            );
          } else {
            // Initialization succeeded, show the login page
            return LoginPage();
          }
        },
      ),
    );
  }
}
