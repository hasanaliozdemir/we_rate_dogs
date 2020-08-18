import 'package:flutter/material.dart';
import 'package:anketdemoapp/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

enum FormType { login, register, reset }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _email, _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void sendResetEmail() {}

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print("Signed In:  $userId");
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print("Registered User:  $userId");
        }
        widget.onSignedIn();
      } catch (e) {
        print("error: $e");
      }
    } else {}
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToReset() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.reset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.reset) {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: "E-Mail"),
          validator: (value) => value.isEmpty ? "E-Mail can\'t be empty" : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 30,
        ),
      ];
    } else {
      return [
        TextFormField(
          decoration: InputDecoration(labelText: "E-Mail"),
          validator: (value) => value.isEmpty ? "E-Mail can\'t be empty" : null,
          onSaved: (value) => _email = value,
        ),
        SizedBox(
          height: 30,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value) =>
              value.isEmpty ? "Password can\'t be empty" : null,
          onSaved: (value) => _password = value,
        ),
        SizedBox(
          height: 30,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 40,
          child: RaisedButton(
            child: Text("Login", style: TextStyle(fontSize: 20)),
            onPressed: validateAndSubmit,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          child: RaisedButton(
            child: Text(
              "Don't have an account ? \n Create Account",
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: moveToRegister,
            color: Colors.black38,
          ),
          height: 40,
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          child: RaisedButton(
            child: Text("Forgot password ?"),
            onPressed: moveToReset,
            color: Colors.black38,
          ),
          height: 35,
        )
      ];
    }
    if (_formType == FormType.register) {
      return [
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          child: Text("Create an Account", style: TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          child: Text(
            "Have an Account? Login",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: moveToLogin,
        )
      ];
    } else {
      return [
        SizedBox(
          height: 30,
        ),
        SizedBox(
          child: RaisedButton(
            child: Text("Send E-mail", style: TextStyle(fontSize: 25)),
            onPressed: sendResetEmail,
          ),
          height: 50,
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          child: Text(
            "Have an Account? Login",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
