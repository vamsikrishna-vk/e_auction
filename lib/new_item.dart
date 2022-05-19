import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class newItem extends StatefulWidget {
  @override
  State<newItem> createState() => _newItemState();
}

class _newItemState extends State<newItem> {
  final TextEditingController itemname = TextEditingController();
  final TextEditingController itemprice = TextEditingController();
  final TextEditingController itemdescription = TextEditingController();
  String downloadUrl = "";
  String icon = 'upload';
  String Imagename = "Upload Picture";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Item"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            text(itemname, "Item Name"),
            SizedBox(height: 20),
            text(itemprice, "Item Price"),
            SizedBox(height: 20),
            text(itemdescription, "Item Description"),
            SizedBox(height: 20),
            SizedBox(
                height: 50.0,
                child: InkWell(
                    onTap: () => {
                          if (icon == 'upload')
                            {
                              uploadImage(),
                            },
                          if (icon == 'uploaded')
                            {
                              setState(() => {
                                    downloadUrl = "",
                                    icon = 'upload',
                                    Imagename = "Upload picture",
                                  })
                            }
                        },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 14.0, bottom: 10.0, top: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (icon == 'upload')
                            (Icon(
                              Icons.upload_rounded,
                              color: Colors.white54,
                            )),
                          if (icon == 'uploading')
                            (SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )),
                          if (icon == 'uploaded')
                            (Icon(Icons.clear, color: Colors.white54)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            Imagename.toString(),
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ))),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () => {
                uploaddata(itemname.text.trim(), itemdescription.text.trim(),
                    itemprice.text.trim(), downloadUrl)
              },
              child: Text("Upload"),
            )
          ],
        ),
      ),
    );
  }

  Widget text(controller, name) {
    return SizedBox(
        height: 50.0,
        child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: name,
              filled: true,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            )));
  }

  Future getFileFromNetworkImage(imageUrl) async {
    var response = await http.get(imageUrl);
    return response.bodyBytes;
  }

  Random _rnd = Random();
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    bool stat = true;
    var permissionStatus;
    //Check Permissions
    if (!kIsWeb) {
      await Permission.photos.request();

      permissionStatus = await Permission.photos.status;
      // stat = permissionStatus.isGranted;
    }
    var file;

    if (!kIsWeb) {
      image = await _imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        setState(() {
          Imagename = "Fimage" + getRandomString(5) + ".jpeg";
          icon = 'uploading';
        });
        var snapshot = await _firebaseStorage
            .ref()
            .child(Imagename)
            .putFile(file)
            .whenComplete(() async => {
                  setState(() {
                    Imagename = Imagename;
                    icon = 'uploaded';
                  }),
                });
        downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
      } else {
        print('No Image Path Received');
      }
    }
  }

  void uploaddata(name, description, price, image) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var firebaseUser = FirebaseAuth.instance.currentUser;

    await firestoreInstance
        .collection("products")
        .doc()
        .set({
          "productname": name,
          "productdescription": description,
          "productprice": price,
          "productimage": image,
          "admin": firebaseUser.uid,
          "time": DateTime.now(),
          "active": true
        }, SetOptions(merge: true))
        .then((_) {})
        .whenComplete(() => {Navigator.pop(context)});
  }
}
