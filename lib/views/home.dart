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
    // final authController = AuthController.to;

    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authController) =>
        // controller.firebaseUser == null
        //     ? Center(child: CircularProgressIndicator())
        //     :
        authController.firebaseUser.value == null
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
                          // authController.firebaseUser.value == null ? Container() : Obx(() =>Text(authController.firebaseUser.value!.uid),),
                          // authController == null || authController.firebaseUser.value == null ? Container() : Obx(() => Text(authController.firebaseUser.value!.email!),),
                          // FormVerticalSpace(),
                          PrimaryButton(labelText: '기초 학습', onPressed: () => Get.toNamed('basic_course'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '공지 사항', onPressed: () => Get.toNamed('notice'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '정보 수정', onPressed: () => Get.toNamed('edit_info'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '휴대폰 인증', onPressed: () => Get.toNamed('phone_auth'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '실시간 채팅', onPressed: () => Get.toNamed('chat_room'),),
                          FormVerticalSpace(),
                          PrimaryButton(labelText: '문의 사항', onPressed: () => Get.toNamed('chat_room'),),
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
                            onPressed: authController.signOut,
                          ),
                        ],
                      ),
                  ))),
                    )));
  }
}
