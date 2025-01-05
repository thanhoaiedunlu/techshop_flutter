import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FacebookLoginScreen(),
    );
  }
}

class FacebookLoginScreen extends StatefulWidget {
  @override
  _FacebookLoginScreenState createState() => _FacebookLoginScreenState();
}

class _FacebookLoginScreenState extends State<FacebookLoginScreen> {
  Map<String, dynamic>? _userData;

  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        setState(() {
          _userData = userData;
        });
      } else {
        print('Login failed: ${result.message}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> _logout() async {
    await FacebookAuth.instance.logOut();
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Facebook Login')),
      body: Center(
        child: _userData != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${_userData!['name']}'),
            Text('Email: ${_userData!['email']}'),
            Text('ID: ${_userData!['id']}'),
            Text('Phone: ${_userData!['phone'] ?? 'No phone number'}'),
            _userData!['picture'] != null
                ? Image.network(_userData!['picture']['data']['url'])
                : Container(),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        )
            : ElevatedButton(
          onPressed: _loginWithFacebook,
          child: Text('Login with Facebook'),
        ),
      ),
    );
  }


}
