import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:foundation/models/models.dart';
import 'package:get/get.dart';
import 'package:characters/characters.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  var _lastRow = 0;
  final FETCH_ROW = 7;
  var stream;
  var randomGenerator = Random();
  var weekDayList = ['일', '월', '화', '수', '목', '금', '토', '일'];

  // int min = 1, max = 49;
  // var randomNumber = 1 + rnd.nextInt(48);일
  ScrollController _scrollController = new ScrollController();
  var noticeDbRef = FirebaseFirestore.instance.collection('Notice');
  final authController = AuthController.to;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  var bannerId;

  @override
  void initState() {
    stream = newStream();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          mounted) {
        setState(() => stream = newStream());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> newStream() {
    return noticeDbRef
        .orderBy("createdAt", descending: true)
        .limit(FETCH_ROW * (_lastRow + 1))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Notice'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      _buildBody(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.toNamed('add_notice');
          },
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    // print("warning");
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data!.docs);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        controller: _scrollController,
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          // print("i : " + i.toString());
          final currentRow = (i + 1) ~/ FETCH_ROW;
          if (_lastRow != currentRow) {
            _lastRow = currentRow;
          }
          print("lastrow : " + _lastRow.toString());
          return _buildListItem(context, snapshot[i]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final notice = NoticeModel.fromSnapshot(data);
    return Padding(
      key: ValueKey(notice.id),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.6)),
          // boxShadow: [
          //   BoxShadow(
          //       offset: Offset(0, 0), blurRadius: 5, color: Colors.black38)
          // ],
        ),
        child: ListTile(
          title: Stack(children: [
            Positioned(
              right: 5,
              top: 20,
              child: Text(
                '${notice.createdAt.toString().substring(0, 10)}(${weekDayList[notice.createdAt.weekday]})',
                style: TextStyle(
                    fontFamily: 'SLEIGothic', color: Colors.grey, fontSize: 12),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                // height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          Stack(children: [
                            Text(
                              '${notice.writer}',
                              style: TextStyle(fontFamily: 'SLEIGothic'),
                            ),
                          ])
                          // 이 뿐 name, grade 로 변경돼야
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     // 좋아요 누르지 않은 경우 빨간 하트로 바꾸고 좋아요+1 해줘야 함
                        //     // 좋아요 리스트에 내가 없는 경우
                        //     // if (notice.likeList != null &&
                        //     //     !notice.likeList.contains(currentUser.email)) {
                        //     //   FirebaseFirestore.instance
                        //     //       // ignore: missing_return
                        //     //       .runTransaction((transaction) {
                        //     //     var ref = noticeDbRef.doc(notice.id);
                        //     //     Future<DocumentSnapshot> doc =
                        //     //         transaction.get(ref);
                        //     //     // transaction.update(ref, {'like' : diary.like + 1});
                        //     //
                        //     //     var addLikeList = [];
                        //     //     // 좋아요 수는 0보다 큰데 내가 아직 좋아요 안눌렀을 때
                        //     //     if (notice.likeList != null &&
                        //     //         !notice.likeList
                        //     //             .contains(currentUser.email)) {
                        //     //       notice.likeList.add(currentUser.email);
                        //     //       addLikeList = notice.likeList;
                        //     //     } // 좋아요 클릭이 최초인 경우
                        //     //     else {
                        //     //       addLikeList.add(currentUser.email);
                        //     //       print(addLikeList);
                        //     //     }
                        //     //     transaction
                        //     //         .update(ref, {'likeList': addLikeList});
                        //     //   });
                        //     // }
                        //     // // 이미 좋아요 누른 경우 또 누르면 빈 하트로 바꾸고 좋아요-1 해줘야 함
                        //     // else {
                        //     //   FirebaseFirestore.instance
                        //     //       .runTransaction((transaction) {
                        //     //     var ref = noticeDbRef.doc(notice.id);
                        //     //     var deletedLikeList = [];
                        //     //     if (notice.likeList != null &&
                        //     //         notice.likeList
                        //     //             .contains(currentUser.email)) {
                        //     //       int index =
                        //     //           notice.likeList.indexOf(currentUser.email);
                        //     //       notice.likeList.removeAt(index);
                        //     //       deletedLikeList = notice.likeList;
                        //     //
                        //     //       transaction.update(
                        //     //           ref, {'likeList': deletedLikeList});
                        //     //     }
                        //     //   });
                        //     // }
                        //   },
                        //   child: Container(
                        //       width: MediaQuery.of(context).size.width * 0.1,
                        //       height: MediaQuery.of(context).size.width * 0.1,
                        //       // 좋아요 리스트에 내가 있는지 없는지 보고 아이콘 달리 보여주기
                        //       child: notice.likeList != null &&
                        //               notice.likeList.contains(currentUser.email)
                        //           ? Icon(Icons.favorite,
                        //               size: MediaQuery.of(context).size.width *
                        //                   0.08,
                        //               color: Colors.redAccent)
                        //           : Icon(Icons.favorite_border,
                        //               size: MediaQuery.of(context).size.width *
                        //                   0.08,
                        //               color: Colors.black87)),
                        // ),
                        // SizedBox(width: 5),
                        // notice.likeList != null && notice.likeList.length > 1
                        //     ? InkWell(
                        //         onTap: () => likeListPopup(notice),
                        //         child: Row(
                        //           children: [
                        //             Text(
                        //                 '${notice.likeList[0].toString()}님 외 ${(notice.likeList.length - 1).toString()}명이 좋아합니다.',
                        //                 style: TextStyle(
                        //                     fontFamily: 'SLEIGothin',
                        //                     fontSize: 11)),
                        //           ],
                        //         ),
                        //       )
                        //     : notice.likeList.length > 0
                        //         ? InkWell(
                        //             onTap: () => likeListPopup(notice),
                        //             child: Text(
                        //                 '${notice.likeList.length.toString()}명이 좋아합니다.',
                        //                 style: TextStyle(
                        //                     fontFamily: 'SLEIGothin',
                        //                     fontSize: 11)),
                        //           )
                        //         : Text('좋아요를 눌러보세요.',
                        //             style: TextStyle(
                        //                 fontFamily: 'SLEIGothin',
                        //                 fontSize: 11)),
                      ],
                    ),
                    SizedBox(height: 5),
                    notice.title != null
                        ? ExpandablePanel(
                            header: Text(
                              notice.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            collapsed: Text(notice.description + " ...더보기",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            expanded: Text(
                              notice.description,
                              softWrap: true,
                            ),
                          )
                        // Expandable(
                        //   collapsed: Text(notice.description),
                        //   expanded: Text(notice.description),
                        // )
                        // ? questionAndAnswer(
                        //     notice.title, notice.description.characters)
                        : SizedBox(),
                    SizedBox(height: 5),
                  ],
                )),
            authController.firestoreUser.value!.email != null
                ? Positioned(
                    right: 5,
                    bottom: 5,
                    child: InkWell(
                        onTap: () {
                          // 관리자 게시글 삭제기능
                          checkDeletePopup(notice);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.redAccent.withOpacity(0.8),
                            size: 30,
                          ),
                        )))
                : SizedBox(),
          ]),
        ),
      ),
    );
  }

  // feedPopup(diary, months) async {
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Stack(children: [
  //             Row(
  //               children: [
  //                 CircleAvatar(
  //                   backgroundImage: diary.profileUrl != null &&
  //                           diary.profileUrl.length > 4
  //                       ? NetworkImage(diary.profileUrl)
  //                       : AssetImage(
  //                           '/assets/images/animal/${diary.randomNumber}.png'),
  //                   backgroundColor: Colors.grey,
  //                 ),
  //                 SizedBox(width: 20),
  //                 Text(
  //                   '${diary.userName} ($months개월)',
  //                   style: TextStyle(fontFamily: 'SLEIGothic'),
  //                 )
  //               ],
  //             ),
  //           ]),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 diary.imageUrl != null
  //                     ? diary.imageUrl != ""
  //                         ? CachedNetworkImage(imageUrl: diary.imageUrl)
  //                         : Container()
  //                     : Center(
  //                         child: Container(
  //                             width: MediaQuery.of(context).size.width * 0.1,
  //                             height: MediaQuery.of(context).size.width * 0.1,
  //                             child: LoadingIndicator(
  //                               indicatorType: Indicator.lineScalePulseOut,
  //                               color: Colors.lightBlue,
  //                             ))),
  //                 SizedBox(height: 5),
  //                 titleAndContentAll(diary.title, diary.content),
  //               ],
  //             ),
  //           ),
  //           insetPadding: EdgeInsets.all(10),
  //           actions: [
  //             TextButton(
  //               child: Container(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Text('닫기',
  //                     style: TextStyle(
  //                         fontFamily: 'SLEIGothic',
  //                         color: Colors.grey,
  //                         fontSize: 20)),
  //               ),
  //               onPressed: () async {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  likeListPopup(diary) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('좋아요 ${diary.likeList.length.toString()}개',
                style: TextStyle(fontFamily: 'SLEIGothic')),
            content: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: diary.likeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Row(
                        children: [
                          Text(diary.likeList[index],
                              style: TextStyle(
                                  fontFamily: 'SLEIGothic', fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            insetPadding: EdgeInsets.all(10),
            actions: [
              TextButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('닫기',
                      style: TextStyle(
                          fontFamily: 'SLEIGothic',
                          color: Colors.grey,
                          fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  questionAndAnswer(question, Characters answer) {
    var subStringAnswer;
    var answerLength = 0;
    if (answer != null) {
      answerLength = answer.length;
    }
    if (answer != null && answerLength > 10) {
      subStringAnswer = answer.skipLast(10).toString();
    } else {
      subStringAnswer = answer;
    }

    return question == null
        ? SizedBox()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      question != null && question.length > 30
                          ? "$question".substring(0, 30) + "..."
                          : "$question",
                      style: TextStyle(
                          fontFamily: 'SLEIGothic',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  color: Colors.black54, width: 0.5))),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          // answer != null && answer.length > 30
                          //     ? "${answer.skipLast(30).toString()}" + "..."
                          //     : "$answer",
                          subStringAnswer.toString(),
                          style: TextStyle(
                              fontFamily: 'SLEIGothic',
                              color: Colors.black54,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          );
  }

  titleAndContentAll(title, content) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                "$title",
                style: TextStyle(
                    fontFamily: 'SLEIGothic',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.lightBlue),
              ),
            ),
          ],
        ),
        SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(color: Colors.black54, width: 0.5))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "$content",
                    style: TextStyle(
                        fontFamily: 'SLEIGothic',
                        color: Colors.black54,
                        fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  checkDeletePopup(diary) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('피드 삭제',
                style: TextStyle(
                  fontFamily: 'SLEIGothic',
                )),
            content: Text("해당 게시글을 삭제하시겠습니까?",
                style: TextStyle(
                    fontFamily: 'SLEIGothic', color: Colors.redAccent)),
            actions: [
              TextButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: TextStyle(
                          fontFamily: 'SLEIGothic',
                          color: Colors.lightBlue,
                          fontSize: 20)),
                ),
                onPressed: () async {
                  // batch 생성
                  WriteBatch writeBatch = FirebaseFirestore.instance.batch();

                  // Feed 게시글 삭제
                  writeBatch.delete(FirebaseFirestore.instance
                      .collection('feed')
                      .doc(diary.id));

                  // batch end
                  writeBatch.commit();

                  Get.snackbar("삭제", "게시글 삭제 완료");
                  Get.offAll("/");
                },
              ),
              TextButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('취소',
                      style: TextStyle(
                          fontFamily: 'SLEIGothic',
                          color: Colors.grey,
                          fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
