import 'dart:io';

import 'package:capstone_chaule/noteui/editnote.dart';
import 'package:capstone_chaule/noteui/note.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String userImageUrl = "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c3VtbWVyJTIwd2FsbHBhcGVyfGVufDB8fDB8fA%3D%3D&w=1000&q=80";
String userName = "Chau";

class EditAccountPage extends StatefulWidget {

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {

  // ===========================================================================
  // This edit account page shows up with a top app bar containing the page's
  // title. Users can change the avatar and the account's name by tapping on
  // the avatar or the name.
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Account"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Edit avatar
            GestureDetector(
              child: Avatar(size:200, imageUrl: userImageUrl),
              onTap: () async {
                XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                File? imageFile;
                  if(image == null)
                    imageFile = null;
                  else
                    imageFile = File(image.path);
                if(imageFile != null){
                  String randomString = getRandString(32);
                  await FirebaseStorage.instance.ref("Image/${randomString}").putFile(
                      imageFile
                  );
                  userImageUrl = await FirebaseStorage.instance.ref("Image/${randomString}").getDownloadURL();
                  setState(() {});
                };
              },
            ),

            // Edit account's name
            GestureDetector(
              child: Text(userName),
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    return Dialog(
                      child: Container(
                        height: 200,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextField(controller: controller),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  userName = controller.text;
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Change name"),
                            )
                          ],
                        )
                      )
                    );
                  }
                );
              }
            )
          ],
        )
      )
    );
  }
}

