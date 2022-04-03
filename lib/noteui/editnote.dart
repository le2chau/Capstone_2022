import 'dart:async';
import 'dart:io';

import 'package:capstone_chaule/AccountUI/editaccount.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:math';
import 'dart:convert';

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}

class EditNotePage extends StatefulWidget{

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  DateTime selecteddate = DateTime.now();
  File? imageFile = null;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  // ===========================================================================
  // This add note page shows up with a top app bar containing the page's
  // title and Done text button to finish. The next part of the screen is the
  // body part that shows the place to add image, title, change the date, and
  // content of the note.
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        actions: [
          TextButton(
            onPressed: ()  async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              );

              // Create random string in the database
              String? imageUrl;
              if(imageFile != null){
                String randomString = getRandString(32);
                await FirebaseStorage.instance.ref("Image/${randomString}").putFile(imageFile!);
                imageUrl = await FirebaseStorage.instance.ref("Image/${randomString}").getDownloadURL();
              }
              FirebaseDatabase.instance.ref("${getRandString(32)}").set({
                  "title": titleController.text,
                  "content": contentController.text,
                  "date": selecteddate.toString(),
                  "image": imageUrl,
                  "avatar": userImageUrl,
                  "name": userName,
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Done", style: TextStyle(color: Colors.white),),
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [

              // Add picture
              GestureDetector(
                  onTap: () async {
                    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    setState(() {
                      if(image == null)
                        imageFile = null;
                      else
                        imageFile = File(image.path);
                    });
                  },
                  child: imageFile == null?  Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("Add Picture")
                    ],
                  ) :
                  Image.file(
                    imageFile!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
              ),
              SizedBox(height: 20),

              // Add note title
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Note title"),
              ),
              SizedBox(height: 20),

              // Edit created day
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            color: Colors.white,
                            child: CupertinoDatePicker(
                                onDateTimeChanged: (DateTime value) {
                                  setState((){
                                    selecteddate = value;
                                  });
                                }
                            )
                        );
                      }
                  );
                },
                child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 12),
                      Text(selecteddate.toString())
                    ]
                ),
              ),

              // Add note content
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: "Note content"),
                maxLines: 10,
              ),
            ]
        ),
      )
    );
  }
}



