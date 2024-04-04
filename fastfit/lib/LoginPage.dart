import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ProfileScreen.dart';
import 'RegisterPage.dart';


TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {

  // Login function
  Future<void> _loginUsingEmailPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text);
      User? user = userCredential.user;

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } else {
        // Handle null user
        print('Login failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.message}');
      // Handle login failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              SizedBox(height: 24.0),
              ElevatedButton(

                onPressed: () => _loginUsingEmailPassword(context),
                child: Text('Login'),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to RegisterPage
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

