import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String id;
  final String writer;
  final String title;
  final String description;
  final int read;
  final DateTime createdAt;

  NoticeModel(
      {required this.id, required this.writer,
        required this.title,
        required this.description,
        required this.read,
        required this.createdAt});

  // factory NoticeModel.fromMap(Map data) {
  //   return NoticeModel(id: data['id'], writer: data['writer'], createdAt: data['createdAt'].toDate());
  // }

  Map<String, dynamic> toJson() => {
        "id": id,
        "writer": writer,
        "createdAt": createdAt,
        "title": title,
    "description": description,
    "read": read,
      };

  NoticeModel.fromMap(var data)
      : id = data['id'],
        writer = data['writer'],
        title = data['title'],
        description = data['description'],
        read = data['read'],
        createdAt = data['createdAt'].toDate();

  NoticeModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
