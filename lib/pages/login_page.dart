import 'package:flutter/material.dart';
import 'package:anketdemoapp/auth.dart';
class LoginPage extends StatefulWidget {
  LoginPage({this.auth,this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage>{
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formType == FormType.login){
          String userId = await widget.auth.signInWithEmailAndPassword(_email,_password);
          print("Signed In:  $userId");
        }
        else {
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
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
    return [
      TextFormField(
        decoration: InputDecoration(labelText: "E-Mail"),
        validator: (value) => value.isEmpty ? "E-Mail can\'t be empty" : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Password"),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password can\'t be empty" : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if(_formType == FormType.login){
      return [
        RaisedButton(
          child: Text("Login", style: TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          child: Text(
            "Create Account",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: moveToRegister,
        )
      ];
    }
    else {
      return [
        SizedBox(
          height: 50,
        ),
        RaisedButton(
          child: Text("Create an Account", style: TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        SizedBox(
          height: 50,
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
