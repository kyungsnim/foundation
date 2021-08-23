import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:foundation/views/conversation_room.dart';
import 'package:foundation/widgets/widgets.dart';
import 'package:get/get.dart';

class ChatRoom extends StatelessWidget {
  final authController = AuthController.to;
  final chatController = ChatController.to;

  @override
  Widget build(BuildContext context) {
    getUserInfo();

    return GetBuilder<ChatController>(
      // init: ChatController(),
      builder: (_) {
        return GetBuilder<AuthController>(
          // init: AuthController(),
          builder: (_) {
            return Scaffold(
              appBar: AppBar(title: Text('실시간 채팅'.tr)),
              body: Container(
                width: Get.width,
                height: Get.height,
                child: chatRoomList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(stream: chatController.chatRoomsStream,
        builder: (context, snapshot) {
      QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot<Object?>?;
      return snapshot.hasData ? ListView.builder(
        itemCount: querySnapshot?.size,
        itemBuilder: (context, index) {
          Map<String, dynamic> roomData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
          return ChatRoomTile(roomData['roomId'].toString().replaceAll('_', '').replaceAll(authController.firestoreUser.value!.email, ''), roomData['roomId']);
        },
      ) : Container(child: Center(child: CircularProgressIndicator()));
        });
  }

  getUserInfo() async {
    print('currentUser email : ${authController.firestoreUser.value!.email}');
    chatController.getChatRooms(authController.firestoreUser.value!.email);
  }
}

class ChatRoomTile extends StatelessWidget {
  String username;
  String roomId;
  ChatRoomTile(this.username, this.roomId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ConversationRoom(roomId));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              height: Get.height * 0.1,
              width: Get.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40)
              ),
              child: Center(child: Text('${username.substring(0, 1).toUpperCase()}',)),
            ),
            SizedBox(width: 8),
            Text(username, style: TextStyle(fontSize: 20, color: Colors.blue))
          ],
        )
      )
    );
  }
}
