import 'dart:io';
import 'package:anketdemoapp/pages/dog_add_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class Uploader extends StatefulWidget{
  final File file;
  const Uploader({Key key, this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _UploaderState();
  }

}

class _UploaderState  extends State<Uploader>{
  var time = DateTime.now();



  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://anket-d56f0.appspot.com/");

  StorageUploadTask _uploadTask;

  void _startUpload() {

    String filePath = "Dogs/$time.png";

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }


    showAlertDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      title: Text("Image Uploaded !"),
      content: Text("message"),
      actions: <Widget>[
        FlatButton(
          child: Text("Okey"),
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => DogAddPage(time: time.toString(),),)) ,
        )
      ],
    );

    showDialog(context: context,builder: (BuildContext context) {return alert;});
    }

    @override
    Widget build(BuildContext context) {
      if (_uploadTask != null) {

        /// Manage the task state and event subscription with a StreamBuilder
        return StreamBuilder<StorageTaskEvent>(
            stream: _uploadTask.events,
            builder: (_, snapshot) {
              var event = snapshot?.data?.snapshot;

              double progressPercent = event != null
                  ? event.bytesTransferred / event.totalByteCount
                  : 0;

              return Column(

                children: [
                  if (_uploadTask.isComplete)
                    FlatButton(
                      child: Text("Okey"),
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => DogAddPage(time: time.toString(),),)) ,
                    ),

                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),

                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),

                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                      '${(progressPercent * 100).toStringAsFixed(2)} % '
                  ),
                ],
              );
            });
      } else {
        // Allows user to decide when to start the upload
        return FlatButton.icon(
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        );
      }
    }
}
