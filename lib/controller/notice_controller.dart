import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  static NoticeController to = Get.find();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  WriteBatch writeBatch = FirebaseFirestore.instance.batch();

  bool isLoading = false;

  void addNotice(String noticeId, Map<String, dynamic> noticeData) {
    writeBatch.set(
        FirebaseFirestore.instance.collection('Notice').doc(noticeId), noticeData);
    writeBatch.commit();
  }
}
