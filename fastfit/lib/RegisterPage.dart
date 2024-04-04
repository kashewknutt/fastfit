import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'ProfileScreen.dart';
import 'UserModel.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _nameController = TextEditingController(text: '');
TextEditingController _ageController = TextEditingController(text: '');
TextEditingController _heightController = TextEditingController(text: '');
TextEditingController _weightController = TextEditingController(text: '');
TextEditingController _phoneController = TextEditingController(text: '');

class RegisterPage extends StatelessWidget {
  Future<void> _registerWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Create a UserModel instance
        UserModel newUser = UserModel(
          id: user.uid,
          name: _nameController.text,
          age: double.parse(_ageController.text),
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
          phoneno: double.parse(_phoneController.text),
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Store additional user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          newUser.toJson(),
        );

        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('entries').doc(formattedDate).set(
          {
            'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'height': double.parse(_heightController.text),
            'weight': double.parse(_weightController.text),
          },
        );

        // Navigate to profile screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } else {
        // Handle null user
        print('Registration failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      print('Registration failed: ${e.message}');
      // Handle registration failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Height (cm)'),
                ),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => _registerWithEmailAndPassword(context),
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        )
    );
  }
}
