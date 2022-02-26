import 'package:capstone_chaule/AccountUI/editaccount.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteView extends StatelessWidget{
  final String? title;
  final String? content;
  final String? imageUrl;
  final String? date;
  final String userAvatar;
  final String userName;
  final String serverID;

  const NoteView({Key? key, this.title, this.content, this.imageUrl, this.date,
    required this.userAvatar, required this.userName, required this.serverID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(imageUrl != null)
          Expanded(
            child: Image.network(imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        if(title != null)
          Text(title!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
        if(content != null)
          Text(content!, overflow: TextOverflow.ellipsis),
        Expanded(child: NoteCreator(date: date, userAvatar: userAvatar, userName: userName)),
      ],
    ),
    );


  }

}


class NotePreview extends StatelessWidget{

  final String? title;
  final String? content;
  final String? imageUrl;
  final String? date;
  final String userAvatar;
  final String userName;
  final String serverID;

  const NotePreview({Key? key, this.title, this.content, this.imageUrl, this.date,
    required this.userAvatar, required this.userName, required this.serverID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(context: context,
            builder: (context){
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              FirebaseDatabase.instance.ref(serverID).remove();
            },
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Delete", style: TextStyle(color: Colors.red),)
                    ],
                  ),
              )
          );
            }
        );
      },
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return NoteView(
                title: title,
                content: content,
                imageUrl: imageUrl,
                userAvatar: userAvatar,
                userName: userName,
                date: date,
                serverID: serverID,
              );
            }
        ));
      },

      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.black12
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(imageUrl != null)
                Expanded(
                  child: Image.network(imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              if(title != null)
                Text(title!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              if(content != null)
                Text(content!, overflow: TextOverflow.ellipsis),
              Expanded(child: NoteCreator(date: date, userAvatar: userAvatar, userName: userName)),
            ],
          )
      ),
    );
  }
}

class NoteCreator extends StatelessWidget{
  final String? date;
  final String userName;
  final String userAvatar;

  const NoteCreator({Key? key, this.date,
    required this.userName, required this.userAvatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(imageUrl: userAvatar),
          SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SizedBox()),
              Text("Created by $userName"),
              if(date != null)
              Text(date!.substring(0, 10)),
              Expanded(child: SizedBox()),
            ],
          )
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget{
  final double size;
  final String imageUrl;


  const Avatar({Key? key, this.size = 25,
    required this.imageUrl
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}