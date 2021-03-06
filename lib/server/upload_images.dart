//import packages
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

//import files
import '../views/nav_bar.dart';

class MultiPicker extends StatefulWidget {
  final String dishId;

  MultiPicker({Key key, this.dishId}) : super(key: key);

  @override
  _MultiPickerState createState() => _MultiPickerState();
}

class _MultiPickerState extends State<MultiPicker> {
  List<Asset> images = List<Asset>();
  List allUrl = List();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Future saveImage(Asset asset, int count) async {
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('dish_image')
        .child(widget.dishId)
        .child("imageNumber" + count.toString() + '.jpeg');
    StorageUploadTask uploadTask = ref.putData(imageData);

    await uploadTask.onComplete;

    var url = await ref.getDownloadURL();

    addUrl(url);
  }

  // Add Url to Dish Document on Firebase
  addUrl(url) async {
    final ref =
        Firestore.instance.collection('dishInfo').document(widget.dishId);
    await ref.updateData({
      'dishUrl': FieldValue.arrayUnion([url])
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  void backHome() {
    Navigator.pop(
        context, new MaterialPageRoute(builder: (context) => NavBar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Add Images",
          style: TextStyle(
            fontSize: 24,
            fontFamily: '.SF Pro Display',
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(120, 115, 115, 1),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Pick images"),
            onPressed: loadAssets,
          ),
          RaisedButton(
              child: Text("upload images"),
              onPressed: () {
                for (var i = 0; i < images.length; i++) {
                  saveImage(images[i], i);
                }
                backHome();
              }),
          Expanded(child: buildGridView()),
        ],
      ),
    );
  }
}
