import 'package:chating/helper/constants.dart';
import 'package:chating/services/database.dart';
import 'package:chating/widgets/widget.dart';
import 'package:flutter/material.dart';
import "string_extension.dart";

class ConversationScreen extends StatefulWidget {
  final String chatroomid;
  final String userName;
  ConversationScreen(this.chatroomid, this.userName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController messageController = TextEditingController();
  Stream chatMessagesStream;
  // ignore: non_constant_identifier_names
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data()["message"],
                        snapshot.data.documents[index].data()["sendBy"] ==
                            Constants.myName);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "sendBy": Constants.myName,
        "message": messageController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      databaseMethods.addConversationMessages(widget.chatroomid, messageMap);

      setState(() {
        messageController.text = "";
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomid).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: chatBar(widget.userName.capitalize()),
        body: Container(
          child: Stack(
            children: [
              ChatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Text Message",
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 150 : 24, right: isSendByMe ? 24 : 150),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
