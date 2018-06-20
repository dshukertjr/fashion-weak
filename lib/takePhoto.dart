import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:async';
import 'dart:core';
import 'dart:io';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;
var currentUser = _firebaseAuth.onAuthStateChanged;
final FirebaseStorage _storage = FirebaseStorage.instance;

class TakePhotoPage extends StatefulWidget {
  final String title;
  TakePhotoPage({Key key, this.title}) : super(key: key);

  @override
  _TakePhotoPageState createState() => new _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  File _image;

  void test() {
    final clothesKey = _firestore.collection("clothes").document().documentID;
    print(clothesKey);
    return;
  }

  Future getImage() async {
    print("get image called");
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    await _uploadFile();
  }

  Future<Null> _uploadFile() async {
    // final Directory systemTempDir = Directory.systemTemp;
    final File file = _image;
    // final String rand = "${new Random().nextInt(10000)}";
    var currentUser = await _firebaseAuth.currentUser();
    if (currentUser == null) {
      await _firebaseAuth.signInAnonymously();
      currentUser = await _firebaseAuth.currentUser();
    }
    final clothesKey = _firestore.collection("clothes").document().documentID;
    final StorageReference ref = _storage
        .ref()
        .child('clothes')
        .child(currentUser.uid.toString())
        .child(clothesKey);
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      new StorageMetadata(
        cacheControl: 'public,max-age=3600',
      ),
    );

    Navigator.pop(context);
    final Uri downloadUrl = (await uploadTask.future).downloadUrl;
    print(downloadUrl.toString());
    final time = new DateTime.now();
    _firestore.document("clothes/${clothesKey}").setData({
      "imageUrl": downloadUrl.toString(),
      "uid": currentUser.uid,
      "time": time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("質問投稿")),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // new CachedNetworkImage(
            //   imageUrl:
            //       'https://firebasestorage.googleapis.com/v0/b/fashion-843d7.appspot.com/o/clothes%2FmuTv07hf4gUgOCm8dIawR3QNxAq1%2F-LFNYsQRbOlwyTpvfKou?alt=media&token=dccfacdd-5185-4d62-bbc4-7c7b0d54570e',
            // ),
            // _image == null ? new Container() : new Image.file(_image),
            new FlatButton(
              child: new Text("take photo page"),
              onPressed: () => getImage(),
              // onPressed: () => test(),
            ),
          ],
        ),
      ),
    );
  }
}
