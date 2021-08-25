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
  final FETCH_ROW = 10;
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
                    // controller: _scrollController,
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
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0), blurRadius: 5, color: Colors.white10)
          ],
        ),
        child: ListTile(
          title: Stack(children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                // height: 200,
                child: notice.title != null
                    ? ExpandablePanel(
                        header: RichText(
                            text: TextSpan(
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                children: [
                              TextSpan(
                                text: notice.title,
                              ),
                              TextSpan(text: '   '),
                              TextSpan(
                                style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 12),
                                  text:
                                      ' ${notice.createdAt.toString().substring(0, 10)}(${weekDayList[notice.createdAt.weekday]})')
                            ])),
                        collapsed: Text(notice.description,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 내용
                            Text(
                              notice.description,
                              softWrap: true,
                            ),
                            /// 댓글


                            /// 댓글 작성 창

                            /// 관리자용 삭제버튼
                            authController.firestoreUser.value!.email != null
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
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
                                        )),
                                  ],
                                )
                                : SizedBox(),
                          ],
                        ),
                      )
                    : SizedBox()),

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

  checkDeletePopup(notice) async {
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
                      .collection('Notice')
                      .doc(notice.id));

                  // batch end
                  writeBatch.commit();

                  Navigator.pop(context);
                  Get.snackbar("삭제", "공지사항 삭제 완료");
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
