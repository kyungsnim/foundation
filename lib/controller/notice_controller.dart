import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  static NoticeController to = Get.find();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  WriteBatch writeBatch = FirebaseFirestore.instance.batch();
  DateTime _createdAt = DateTime.now();
  DateTime picked = DateTime.now();

  bool isLoading = false;

  void addNotice(String noticeId, Map<String, dynamic> noticeData) {
    writeBatch.set(
        FirebaseFirestore.instance.collection('Notice').doc(noticeId),
        noticeData);
    writeBatch.commit();
  }

  void setCreatedAt(context) async {
    picked = (await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(_createdAt.year - 5),
      lastDate: DateTime(_createdAt.year + 5),
      builder:
          (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme:
            ColorScheme.light().copyWith(
              primary: Colors.lightBlue,
            ),
            buttonTheme: ButtonThemeData(
                textTheme:
                ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    )
    )!;
    update();
  }
}
