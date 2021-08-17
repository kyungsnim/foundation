import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundation/controller/controllers.dart';
import 'package:foundation/models/user_model.dart';
import 'package:foundation/widgets/form_input_field.dart';
import 'package:foundation/widgets/widgets.dart';
import 'package:get/get.dart';

class EditInfo extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authController.nameController.text =
        authController.firestoreUser.value!.profileName;
    authController.emailController.text =
        authController.firestoreUser.value!.email;

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
                            controller: authController.nameController,
                            iconPrefix: Icons.person,
                            labelText: 'auth.nameFormField'.tr,
                            // validator: Validator().name,
                            onChanged: (value) => null,
                            onSaved: (value) =>
                                authController.nameController.text = value!,
                          ),
                          FormVerticalSpace(),
                          FormInputFieldWithIcon(
                            controller: authController.emailController,
                            iconPrefix: Icons.email,
                            labelText: 'auth.emailFormField'.tr,
                            // validator: Validator().email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => null,
                            onSaved: (value) =>
                                authController.emailController.text = value!,
                          ),
                          FormVerticalSpace(),
                          PrimaryButton(
                              labelText: 'auth.updateUser'.tr,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  UserModel _updatedUser = UserModel(
                                    uid:
                                        authController.firestoreUser.value!.uid,
                                    profileName: authController.nameController.text,
                                    email: authController.emailController.text,
                                  );
                                  _updateUserConfirm(
                                      context,
                                      _updatedUser,
                                      authController
                                          .firestoreUser.value!.email);
                                  // controller.updateUser(context, user, oldEmail, password);
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _updateUserConfirm(
      BuildContext context, UserModel updatedUser, String oldEmail) async {
    final AuthController authController = AuthController.to;
    final TextEditingController _password = new TextEditingController();
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          'auth.enterPassword'.tr,
        ),
        content: FormInputFieldWithIcon(
          controller: _password,
          iconPrefix: Icons.lock,
          labelText: 'auth.passwordFormField'.tr,
          // validator: (value) {
          //   String pattern = r'^.{6,}$';
          //   RegExp regex = RegExp(pattern);
          //   if (!regex.hasMatch(value!))
          //     return 'validator.password'.tr;
          //   else
          //     return null;
          // },
          obscureText: true,
          onChanged: (value) => null,
          onSaved: (value) => _password.text = value!,
          maxLines: 1,
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text('auth.cancel'.tr.toUpperCase()),
            onPressed: () {
              Get.back();
            },
          ),
          new TextButton(
            child: new Text('auth.submit'.tr.toUpperCase()),
            onPressed: () async {
              await authController.updateUser(
                  context, updatedUser, oldEmail, _password.text);
              Get.offAllNamed('/');
            },
          )
        ],
      ),
    );
  }
}
