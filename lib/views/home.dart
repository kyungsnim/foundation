import 'package:flutter/material.dart';
import 'package:foundation/controller/auth_controller.dart';
import 'package:foundation/widgets/form_vertical_spacing.dart';
import 'package:foundation/widgets/label_button.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => controller.firestoreUser == null
            ? Center(child: CircularProgressIndicator())
            : Scaffold(body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(controller.firestoreUser.value!.uid),
                  Text(controller.firestoreUser.value!.name),
                  FormVerticalSpace(),
                  LabelButton(
                    labelText: '로그아웃',onPressed: controller.signOut,
                  ),
                ],
              ),
            )
          )
        )));
  }
}
