import 'package:foundation/views/sign_up.dart';
import 'package:get/get.dart';
import 'package:foundation/views/views.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => Home()),
    GetPage(name: '/signin', page: () => SignIn()),
    GetPage(name: '/signup', page: () => SignUp()),
    GetPage(name: '/edit_info', page: () => EditInfo()),
    GetPage(name: '/basic_course', page: () => BasicCourse()),
    GetPage(name: '/notice', page: () => Notice()),
    GetPage(name: '/add_notice', page: () => AddNotice()),
    GetPage(name: '/phone_auth', page: () => PhoneAuth()),
    GetPage(name: '/chat_room', page: () => ChatRoom()),
  ];
}