import 'package:anketdemoapp/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anketdemoapp/models/dog.dart';
import 'package:anketdemoapp/widgets/cancel_button.dart';

class DogsPage extends StatelessWidget {
  DogsPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _signOutAlert(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Okey"),
      onPressed: () {
        _signOut();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Logging Out"),
      content: Text("You are going to log out"),
      actions: <Widget>[okButton, CancelButton().cancelButton(context)],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, "/image"),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOutAlert(context),
          ),
        ],
        title: Text("We rate Dogs"),
      ),
      body: SurveyList(),
    );
  }
}

class SurveyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SurveyListState();
  }
}

class SurveyListState extends State {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("dogs").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return buildBody(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 20),
      children:
          snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = Dog.fromSnapshot(data);

    return Padding(
      key: ValueKey(row.name),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(row.imageUrl)),
        ),
        height: 222,
        child: ListTile(
          key: Key(row.id.toString()),
          title: Text(
            row.name,
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 130),
            child: Text(
              row.vote.toString(),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              softWrap: true,
            ),
          ),
          onTap: () => Firestore.instance.runTransaction((transaction) async {
            final freshSnapshot =
                await transaction.get(row.reference); // Snapshot
            final fresh = Dog.fromSnapshot(freshSnapshot); // Anket

            await transaction.update(row.reference, {"vote": fresh.vote + 1});
          }),
        ),
      ),
    );
  }
}
