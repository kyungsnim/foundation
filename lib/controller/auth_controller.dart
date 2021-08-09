import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foundation/models/user_model.dart';
import 'package:foundation/views/home.dart';
import 'package:foundation/views/sign_in.dart';
import 'package:foundation/widgets/loading.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    // get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
      // await isAdmin();
    }

    /// 앱 시작시 기존 로그인했던 사용자라면 바로 HomeUI로, 로그인 필요한 사용자라면 SignInUI 페이지로 이동
    if (_firebaseUser == null) {
      print('Send to signin');
      Get.offAll(() => SignIn());
    } else {
      Get.offAll(() => Home());
    }
  }

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');

    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  /// user data 불러오기
  void fetchUserModel() async {
    // _userData =
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth
          .createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .then((result) async {
        print('uID: ' + result.user!.uid.toString());
        print('email: ' + result.user!.email.toString());
        //get photo url from gravatar if user has one
        // Gravatar gravatar = Gravatar(emailController.text);
        // String gravatarUrl = gravatar.imageUrl(
        //   size: 200,
        //   defaultImage: GravatarImage.retro,
        //   rating: GravatarRating.pg,
        //   fileExtension: true,
        // );

        /// 추가정보 입력받기
        /// final String company;
        /// final String nickName;
        /// final String whatToDo;
        /// final int age;
        /// final int height;
        /// final String bodyStyle;
        /// final String address;
        /// final String married;
        /// final String religion;
        /// final String smoking;
        /// final String drinking;
        /// final String greetings;
        /// final List<String> favoriteListen;
        /// final List<String> introduceMyself;
        /// final List<String> favoriteThings;
        // final info = await Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => RegisterExtraInfoUI()));

        //create the new user object
        UserModel _newUser = UserModel(
            uid: result.user!.uid,
            name: nameController.text,
        );
        // create the user in firestore
        _createUserFirestore(_newUser, result.user!);
        emailController.clear();
        passwordController.clear();
        hideLoadingIndicator();
      });
    } on FirebaseAuthException catch (error) {
      // hideLoadingIndicator();
      Get.snackbar('auth.signUpErrorTitle'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //create the firestore user in users collection
  void _createUserFirestore(user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    update();
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    showLoadingIndicator();
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
      hideLoadingIndicator();
    } catch (error) {
      hideLoadingIndicator();
      Get.snackbar('auth.signInErrorTitle'.tr, 'auth.signInError'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // Sign out
  Future<void> signOut() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    return _auth.signOut();
  }

  // UserModel get userData => _userData.value;
  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();
}
