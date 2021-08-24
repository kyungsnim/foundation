import 'package:flutter/material.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:get/get.dart';

class BasicCourse extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text('Basic Course'.tr)),
          body: Container()
        );
      }
    );
  }
}
