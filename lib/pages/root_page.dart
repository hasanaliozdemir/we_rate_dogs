import 'package:anketdemoapp/pages/dogs_page.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:anketdemoapp/auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

enum AuthStatus { notSignedIn, SignedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.SignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SignedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.SignedIn:
        return DogsPage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
