import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/firebase_options.dart';
import 'package:fluttertask/google.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthService _authService = AuthService();
  User? _user;

  void iniState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          'Welcome to our Shop',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Column(
        children: [
          SizedBox(height: 200),
          Center(
              child: Icon(
            Icons.login,
            size: 100,
          )),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                _handleGoogleSignIn(context);
              },
              child: Text('Login with Google',
                  style: TextStyle(fontSize: 25, color: Colors.black)))
        ],
      ),
    );
  }

  void _handleGoogleSignIn(BuildContext context) async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(
        context,
        '/Homepage',
        arguments: user,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed')),
      );
    }
  }
}
