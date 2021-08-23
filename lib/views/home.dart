import 'package:flutter/material.dart';
import 'package:foundation/controller/auth_controller.dart';
import 'package:foundation/widgets/form_vertical_spacing.dart';
import 'package:foundation/widgets/label_button.dart';
import 'package:foundation/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        // init: AuthController(),
        builder: (controller) =>
        // controller.firebaseUser == null
        //     ? Center(child: CircularProgressIndicator())
        //     :
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
                          PrimaryButton(labelText: '휴대폰 인증', onPressed: () => Get.toNamed('phone_auth'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '실시간 채팅', onPressed: () => Get.toNamed('chat_room'),),
                          FormVerticalSpace(),
                          LabelButton(
                            labelText: '테마변경',
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if(prefs.getString('theme') == 'Dark') {
                                Get.changeTheme(ThemeData.light());
                                prefs.setString('theme', 'Light');
                              } else {
                                Get.changeTheme(ThemeData.dark());
                                prefs.setString('theme', 'Dark');

                              }
                            },
                          ),
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
