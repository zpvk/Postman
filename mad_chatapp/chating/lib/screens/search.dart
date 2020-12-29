import 'package:chating/helper/constants.dart';
import 'package:chating/helper/helperfunction.dart';
import 'package:chating/screens/conversation_screen.dart';
import 'package:chating/services/database.dart';
import 'package:chating/widgets/MybottomBerDemo.dart';
import 'package:chating/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
              );
            },
          )
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatroomAndStartConverastion({String userName}) {
    if (userName != Constants.myName) {
      String chatroomid = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      // ignore: non_constant_identifier_names
      Map<String, dynamic> ChatRoomMap = {
        "users": users,
        "chatroomid": chatroomid
      };

      DatabaseMethods().createChatRoom(chatroomid, ChatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomid,userName)));
    } else {
      print("you cannot send messageto yourself");
    }
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Text(userEmail,
                  style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConverastion(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 19, vertical: 8),
              child: Text("Message",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: iosappBar("Search"),
      body: Container(
          child: Column(
        children: [
          Container(
            color: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Search User Name",
                      hintStyle: TextStyle(color: Colors.white30),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          searchList()
        ],
      )),
    );
  }
}

// class SearchTile extends StatelessWidget {
//   final
//   SearchTile({this.userName, this.userEmail});

//   @override
//   Widget build(BuildContext context) {

// }

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\$a";
  } else {
    return "$a\_$b";
  }
}
