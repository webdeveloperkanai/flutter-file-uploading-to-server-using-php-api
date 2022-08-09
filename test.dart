import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart'; 

import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:http/http.dart' as http;
import 'package:roy_service_2/config.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Media> photos = [];
  String img = '';
  Future getImage() async {
    photos = (await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    ))!; 
    File fl = File.fromUri(Uri.parse(photos.first.path));
    Future<Uint8List> bdt = fl.readAsBytes();
    bdt.then((value) { 
      img = base64Encode(value);
      setState(() {});
    });
    print("IMG code " + img.toString()); 
    print(photos.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 160,
            ),
            photos.length < 1
                ? SizedBox()
                : Image.memory(
                    base64Decode(img),
                    height: 150,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Pick")),
                ElevatedButton(
                    onPressed: () async {
                      print("Image - " + photos[0].thumbPath.toString());

                      http.Response rsp =
                          await http.post(Uri.parse(APP_BASE), body: {
                        "upload_image": "true",
                        "thumbnail": img.toString(),
                      });
                      print("Server response - " + rsp.body.toString());
                      if (rsp.body.toString() == "Success") {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text("Upload success"),
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Text("Upload failed"),
                              );
                            });
                      }
                    },
                    child: Text("Upload")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
