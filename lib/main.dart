import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'AccountUI/editaccount.dart';
import 'noteui/editnote.dart';
import 'noteui/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Use the blue theme for Material widgets.
        primarySwatch: Colors.blue,
      ),
      home: NotePage(),
    );
  }
}

class NotePage extends StatefulWidget {

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<dynamic> noteList = [];

  // Get data from Firebase to the initState
  @override
  void initState() {
    var db = FirebaseDatabase.instance;

    db.ref().onValue.listen(
      (event) {
          noteList.clear();
          if(event.snapshot.value != null)
            noteList.addAll((event.snapshot.value as Map).entries);
          setState(() {});
      }
    );
    super.initState();
  }

  // ===========================================================================
  // This app shows up with a top app bar containing the page's title and the
  // icon to edit the account info. The next part of the screen is the body part
  // that displays all the notes. The final element of this screen is the
  // floating action button leading to the edit note page.
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Community Note"),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EditAccountPage();
                }
              ));
            },
            icon: Icon(Icons.account_box)
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              crossAxisCount: 2,
            ),
            itemCount: noteList.length,
            itemBuilder: (BuildContext context, int index) {
              return NotePreview(
                  imageUrl: noteList[index].value["image"],
                  title: noteList[index].value["title"],
                  content: noteList[index].value["content"],
                  date: noteList[index].value["date"],
                  userAvatar: noteList[index].value["avatar"],
                  userName: noteList[index].value["name"],
                  serverID: noteList[index].key,
              );
            }
          )
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EditNotePage();
                }
            ));
          },
          icon: Icon(Icons.add),
          label: Text("Add Note"),
        ),
    );
  }
}

