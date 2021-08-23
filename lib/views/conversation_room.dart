import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ConversationRoom extends StatelessWidget {
  final authController = AuthController.to;
  final chatController = ChatController.to;
  ConversationRoom(String roomId) {
    chatController.roomId = roomId;
  }

  @override
  Widget build(BuildContext context) {
    getConversation();
    var oppnentId = chatController.roomId == null ? '' : chatController.roomId!.replaceAll('_', '').replaceAll(authController.firestoreUser.value!.email, '');
    return GetBuilder<ChatController>(
      builder: (_) {
        return GetBuilder<AuthController>(
            builder: (_) {
          return Scaffold(
              appBar: AppBar(title: Text('$oppnentId님과의 대화')),
              body: Container(
                  child: Stack(
                    children: [
                      chatMessageList(),
                      Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical:
                          30),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: chatController.messageTextEditingController,
                                  style: TextStyle(color: Colors.black87),
                                  //,
                                ),
                              ),
                              InkWell(
                                  onTap: () => sendMessage(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),

                                        gradient: LinearGradient(
                                            colors:[ Colors.blue, Colors.redAccent])
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Icon(Icons.send, size: 20),
                                  )
                              )
                            ],
                          )
                      )
                      // Text('123312123312'),
                    ],
                  )
              )
          );
        });
      });
  }

  sendMessage() {
    if (chatController.messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': chatController.messageTextEditingController.text,
        'sendBy': authController.firestoreUser.value!.email,
        'sendDt': DateTime.now()
      };

      chatController.addConversationMessages(chatController.roomId!, messageMap);
      chatController.clearMessageTextController();
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatController.chatMessageStream,
      builder: (context, snapshot) {
        QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot<Object?>?;
        return snapshot.hasData
            ? ListView.builder(
              itemCount: querySnapshot?.size,
              itemBuilder: (context, index) {
                Map<String, dynamic> messageData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
                return Column(
                  children: [
                    MessageTile (messageData['message'],
                    messageData['sendBy'] == authController.firestoreUser.value!.email),
                    SizedBox(height: 5),
                    MessageInfo(readTimestamp(messageData['sendDt']), messageData['sendBy'] == authController.firestoreUser.value!.email),
                  ],
                );
              }) : Container();
      }
    );
  }

  String readTimestamp(Timestamp timestamp) {
    int timeToInt = timestamp.seconds;
    var now = DateTime.now();
    var format = DateFormat('HH:mm:ss a');
    var date = DateTime.fromMillisecondsSinceEpoch(timeToInt * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  getConversation() async {
    print('roomId: ${chatController.roomId!}');
    chatController.getConversationMessages(chatController.roomId!);
  }
}

class MessageTile extends StatelessWidget {
  String message;
  bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(top: 10, left: isSendByMe ? 50 : 10, right: isSendByMe ? 10 : 50),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft:
          Radius.circular(10)) : BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight:
          Radius.circular(10)),

          color: isSendByMe ? Colors.yellow : Colors.grey.withOpacity(0.3)
        ),
        child: Text(message, style: TextStyle(color: Colors.black87, fontSize: 16))
      )
    );
  }
}

class MessageInfo extends StatelessWidget {
  String info;
  bool isSendByMe;

  MessageInfo(this.info, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(bottom:5, right: isSendByMe ? 10 : 0, left: isSendByMe ? 0 : 10),
      child: Container(
        // padding: EdgeInsets.all(10),
          child: Text(info, style: TextStyle(color: Colors.black87, fontSize: 12))),
    );
  }
}
