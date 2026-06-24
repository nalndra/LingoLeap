import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  void logout() async {
    await _auth.signOut();
  }
}
