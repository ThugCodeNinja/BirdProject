import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'cllassifier.dart';
import 'color_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:psfinal/classifier.dart';
CollectionReference ref = FirebaseFirestore.instance.collection('birds');
var num = Random().nextInt(1000).toString();
final stro = FirebaseStorage.instance.ref('/foldername' + 'storage' + num);

class speciesPage extends StatefulWidget {
  const speciesPage({Key? key}) : super(key: key);

  @override
  _speciesPageState createState() => _speciesPageState();
}

class _speciesPageState extends State<speciesPage> {
  late Classifier _classifier;
  File? imageFile;
  String? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Image selection", style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white70)),
          backgroundColor: Colors.black45,
          shadowColor: Colors.deepPurple[300],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        actions: <Widget>[TextButton(onPressed: ()
        async {
          String url = 'https://en.wikipedia.org/wiki/';
          category= category?.toLowerCase();
          url = url + "$category";
          await launchUrlString(url, mode: LaunchMode.inAppWebView);
        }, child:Text("Wiki"))],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("85FFBD"),
                hexStringToColor("FFFB7D "),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                  children: [Text("Pick an image from gallery or camera",
                    style: const TextStyle(fontFamily: 'Pacifico',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: Container(
                    child: imageFile != null
                        ? Image.file(
                      imageFile!,
                      fit: BoxFit.fill,
                    )
                        : Image.network(
                      'https://qph.cf2.quoracdn.net/main-qimg-23848025ad1718eb171973d19c865450',
                      fit: BoxFit.fill,
                    ),
                    height: 200.0,
                    width: 170.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.greenAccent,
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: (() {
                                    _getFromGallery();
                                  }),
                                  label: Text("Gallery"),
                                  icon: Icon(Icons.image_outlined),
                                  heroTag: null,
                                ),
                                SizedBox(
                                  width: 75,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: (() {
                                    _getFromCamera();
                                  }),
                                  label: Text("Camera"),
                                  icon: Icon(Icons.camera_rounded),
                                  heroTag: null,
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    color: Colors.black,
                    height: 50.0,
                    width: 150.0,
                    child: Center(
                      child: Text(
                        'Pick image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Predicted :",
                  style: TextStyle(
                      fontFamily: "Inconsolata",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(category != null ? "$category" : ''),
                /*Text("Accuracy :",style: TextStyle(
                    fontFamily: "Inconsolata",
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text("89.00"),*/
              ]
              ),
            ],
          ),
        ),
        /*bottomNavigationBar: Container(
            height: 60,
            child: BottomAppBar(
                elevation: 100.0,
                child: InkWell(
                  onTap: () async {
                    String url = 'https://en.wikipedia.org/wiki/';
                    category= category?.toLowerCase();
                      url = url + "$category";
                    await launchUrlString(url, mode: LaunchMode.inAppWebView);
                  },
                  child: Container(
                    height: 50.0,
                    width: 175,
                    color: Colors.grey,
                    child: Center(
                      child: Text('Wikipedia',
                          style: TextStyle(
                              fontFamily: 'Inconsolata',
                              fontSize: 23,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ))
        )*/
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Admin'),
                accountEmail: Text('20bd1a6748@gmail.com'),
                currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                    child: Image.network(
                      'https://png.pngitem.com/pimgs/s/24-248235_user-profile-avatar-login-account-fa-user-circle.png/',
                      fit: BoxFit.cover,
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://wallpapercave.com/dwp1x/wp2561332.jpg')),
                ),
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () => null,
              ),
              Divider(),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        //final task = stro.putFile(imageFile!.absolute);
        _predict();
      });
    }
  }

  Future _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        //final task = stro.putFile(imageFile!.absolute);
        _predict();
      });
    }
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(imageFile!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      category = pred;
      final imgurl = stro.getDownloadURL();
      ref.add({'prediction': category, 'img': imgurl});
    });
  }
}



