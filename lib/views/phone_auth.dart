import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:foundation/models/user_model.dart';
import 'package:foundation/widgets/widgets.dart';
import 'package:get/get.dart';

class PhoneAuth extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (controller) => controller.firestoreUser.value == null
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Scaffold(
                appBar: AppBar(title: Text('auth.updateProfileTitle'.tr)),
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            FormInputFieldWithIcon(
                              controller: authController.phoneNumberController1,
                              iconPrefix: Icons.phone,
                              labelText: '휴대폰 번호'.tr,
                              // validator: Validator().name,
                              onChanged: (value) => null,
                              onSaved: (value) => authController
                                  .phoneNumberController1.text = value!,
                            ),
                            authController.authOk
                                ? SizedBox()
                                : FormVerticalSpace(),
                            PrimaryButton(
                                labelText: '인증번호 받기'.tr,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                    showLoadingIndicator();

                                    /// verify ID 생성
                                    authController.verifyWithPhoneNumber(
                                        timeout: const Duration(seconds: 60),
                                        codeAutoRetrievalTimeout:
                                            (String verificationId) {},
                                        phoneNumber: "+821088337838",
                                        verificationCompleted:
                                            (phoneAuthCredential) async {
                                          print('otp 문자 옴');
                                          // print(phoneAuthCredential);
                                        },
                                        verificationFailed:
                                            (verificationFailed) async {
                                          print(verificationFailed.code);
                                          print('코드발송 실패');
                                          // hideLoadingIndicator();
                                        },
                                        codeSent: (verificationId,
                                            resendingToken) async {
                                          print('코드 발송');
                                          Get.snackbar('인증번호 발송', '입력하신 번호로 인증번호를 발송하였습니다.',
                                              snackPosition: SnackPosition.BOTTOM,
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                              colorText: Get.theme.snackBarTheme.actionTextColor);
                                          authController.requestedAuth = true;
                                          authController.verificationId =
                                              verificationId;
                                        });
                                    // authController.signInWithPhoneAuthCredential(phoneAuthCredential)
                                  }
                                }),
                            FormVerticalSpace(),
                            FormInputFieldWithIcon(
                              controller: authController.otpController,
                              iconPrefix: Icons.verified_sharp,
                              labelText: '인증번호'.tr,
                              // validator: Validator().name,
                              onChanged: (value) => null,
                              onSaved: (value) => authController
                                  .otpController.text = value!,
                            ),
                            FormVerticalSpace(),
                            PrimaryButton(
                                labelText: '확인'.tr,
                                onPressed: () async {
                                  PhoneAuthCredential phoneAuthCredential =
                                      PhoneAuthProvider.credential(
                                          verificationId:
                                              authController.verificationId,
                                          smsCode: authController
                                              .otpController.text);
                                  authController.signInWithPhoneAuthCredential(
                                      phoneAuthCredential);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
