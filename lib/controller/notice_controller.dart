import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeController extends GetxController {
  static NoticeController to = Get.find();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Rx<String> _title = ''.obs;
  Rx<String> _description = ''.obs;
  DateTime createdDt = DateTime.now();
  // Rx<bool> processing = false.obs;
  bool isLoading = false;

  setTitle() {
    _title = titleController.text as Rx<String>;
    update();
  }

  setDescription() {
    _description = descriptionController.text as Rx<String>;
    update();
  }

  void setLoading() {
    isLoading = !isLoading;
    update();
  }

}