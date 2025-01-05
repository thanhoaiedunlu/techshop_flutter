import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

/// The scopes required by this application.
const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '506553335061-mgd53m1f73n58mli9bcf4pk2818fvign.apps.googleusercontent.com', // Web Client ID
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


void main() {
  runApp(
    const MaterialApp(
      title: 'Google Sign In',
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  const SignInDemo({super.key});

  @override
  State createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;

      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      if (isAuthorized) {
        unawaited(_handleGetContact(account!));
      }
    });

    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    try {
      final http.Response response = await http.get(
        Uri.parse(
            'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
        headers: await user.authHeaders,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'People API returned ${response.statusCode}: ${response.body}');
      }

      final Map<String, dynamic> data =
      json.decode(response.body) as Map<String, dynamic>;
      final String? namedContact = _pickFirstNamedContact(data);

      setState(() {
        if (namedContact != null) {
          _contactText = 'I see you know $namedContact!';
        } else {
          _contactText = 'No contacts to display.';
        }
      });
    } catch (e) {
      setState(() {
        _contactText = 'Error retrieving contact: $e';
      });
      print(e);
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) =>
      (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;

    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) =>
        (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;

      return name?['displayName'] as String?;
    }

    return null;
  }

  Future<void> _handleSignIn() async {
    print('Attempting to sign in...');
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        print('Sign-in aborted by user');
      } else {
        print('Signed in successfully: ${account.displayName}');
      }
    } catch (error) {
      print('Error during sign-in: $error');
    }
  }


  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    setState(() {
      _isAuthorized = isAuthorized;
    });

    if (isAuthorized) {
      unawaited(_handleGetContact(_currentUser!));
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
      _isAuthorized = false;
      _contactText = '';
    });
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;

    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(identity: user),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_isAuthorized) ...<Widget>[
            Text(_contactText),
            ElevatedButton(
              onPressed: () => _handleGetContact(user),
              child: const Text('REFRESH'),
            ),
          ],
          if (!_isAuthorized) ...<Widget>[
            const Text('Additional permissions needed to read your contacts.'),
            ElevatedButton(
              onPressed: _handleAuthorizeScopes,
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: _handleSignIn,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}
