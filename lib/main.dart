import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foundation/controller/auth_controller.dart';
import 'package:foundation/views/sign_in.dart';
import 'package:get/get.dart';

import 'constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Get.put<AuthController>(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      getPages: AppRoutes.routes,
    );
  }
}
