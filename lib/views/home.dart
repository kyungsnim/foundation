import 'package:flutter/material.dart';
import 'package:foundation/controller/auth_controller.dart';
import 'package:foundation/widgets/form_vertical_spacing.dart';
import 'package:foundation/widgets/label_button.dart';
import 'package:foundation/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'views.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        // init: AuthController(),
        builder: (controller) => controller.firebaseUser == null
            ? Center(child: CircularProgressIndicator())
            :
        controller.firestoreUser.value == null
                ? Center(child: CircularProgressIndicator())
                :
        Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                          child: Center(
                              child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(() => Text(controller.firestoreUser.value!.uid),),
                          Obx(() => Text(controller.firestoreUser.value!.profileName),),
                          Obx(() => Text(controller.firestoreUser.value!.email),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '정보 수정', onPressed: () => Get.toNamed('edit_info'),),
                          FormVerticalSpace(),
                          LabelButton(
                            labelText: '로그아웃',
                            onPressed: controller.signOut,
                          ),
                        ],
                      ),
                  ))),
                    )));
  }
}
