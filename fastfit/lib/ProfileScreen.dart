import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserModel.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              UserModel? userData = UserModel.fromJson((snapshot.data?.data() as Map<String, dynamic>?) ?? {});
              return ProfileInfo(userData: userData);
            }
          },
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final UserModel? userData;

  const ProfileInfo({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userData != null
        ? Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileField(label: 'Name', value: userData!.name),
          ProfileField(label: 'Age', value: '${userData!.age}'),
          ProfileField(label: 'Height', value: '${userData!.height} cm'),
          ProfileField(label: 'Weight', value: '${userData!.weight} kg'),
          ProfileField(label: 'Phone Number', value: '${userData!.phoneno}'),
        ],
      ),
    )
        : Text('No user data available');
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87),
          children: [
            TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
