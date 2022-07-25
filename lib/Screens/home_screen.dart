import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newsify_admin/widgets/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

DateTime now = DateTime.now();
String formattedDateTime =
    "${now.year}-${now.month}-${now.day}  ${now.hour}:${now.minute}";
TextEditingController _author = TextEditingController();
TextEditingController _title = TextEditingController();
TextEditingController _body = TextEditingController();
TextEditingController _url = TextEditingController();

File? _image;
String? downloadUrl;
var tmpCheckboxList = [];
final ImagePicker _picker = ImagePicker();

class _HomeScreenState extends State<HomeScreen> {
  Future imagePickerMethod() async {
    final pick =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("Please select an image with .jpg format first.");
      }
    });
  }

  Future firebaseNewsUpload() async {
    final ref = FirebaseFirestore.instance.collection("news");
    ref.add({
      'aaa_time': DateTime.now().millisecond.toString(),
      'title': _title.text,
      'body': _body.text,
      'author': _author.text,
      'url': _url.text,
      'image': downloadUrl,
      'timestamp': formattedDateTime,
      'newsPostedDate': DateTime.now()
    });
  }

  Future firebaseImageUpload() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("news_images")
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    await ref.putFile(_image!);
    downloadUrl = await ref.getDownloadURL();
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.blue,
        action: SnackBarAction(
            textColor: Colors.white, label: "OK!", onPressed: () {}),
      ),
    );
  }

  //This will be a Categories Section
  /*
  getCheckboxItems() {
    categories.forEach((key, value) {
      if (value == true) {
        tmpCheckboxList.add(key);
      }
    });
  }

  Map<String, bool> categories = {
    "electric": true,
    "worldwide": false,
    "crime": false,
    "sports": false,
    "education": false,
    "technology": false,
    "business": false,
    "startup": false,
  };
*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Add A News",
                  style: GoogleFonts.poppins(fontSize: 21),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _author,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Author",
                    labelStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _title,
                  maxLines: 3,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Title",
                    labelStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _body,
                  maxLines: 13,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Body",
                    hintText: "Add news description.",
                    labelStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _url,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "News Url",
                    hintText: "Add news source/url.",
                    labelStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    imagePickerMethod();
                  },
                  child: _image != null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Image.file(_image!))
                      : Column(
                          children: [
                            const Icon(
                              Icons.file_copy,
                              size: 50,
                            ),
                            Text(
                              "Choose a Photo",
                              style: GoogleFonts.aBeeZee(fontSize: 18),
                            )
                          ],
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Checkbox(
                //         value: _sendNotification,
                //         onChanged: (e) {
                //           setState(() {
                //             _sendNotification = !_sendNotification;
                //           });
                //         }),
                //     const Text("Send Notification"),
                //   ],
                // ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result =
                          await InternetAddress.lookup('www.google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        if (_image != null) {
                          if (_author.text.length > 3 &&
                              _title.text.length > 5 &&
                              _body.text.length > 30) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const ProgressDialog(
                                      message: "Uploading....");
                                });
                            await firebaseImageUpload();
                            await firebaseNewsUpload();
                            showSnackBar("News Updated");
                            Navigator.pop(context);
                            setState(() {
                              _author.clear();
                              _title.clear();
                              _body.clear();
                              _url.clear();
                              _image = null;
                              //Sending Notification//
                            });
                          } else {
                            setState(() {
                              showSnackBar(
                                  "Please fill all the boxes with a bit longer content");
                            });
                          }
                        } else {
                          showSnackBar("Please select an image first.");
                        }
                      }
                    } on SocketException catch (_) {
                      showSnackBar("Please Check Your Internet Connection");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Upload',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
