import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Login_controller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString userid = ''.obs;
  late UserCredential userCredential;

  Future<bool> signUp(String email, String Password) async {
    try {
       userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: Password);
       userid.value = userCredential.user!.uid;
       print('User id $userid');

       print('User signed up: ${userCredential.user!.email}');
       return true;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up: $e');
      return false;
    }}
    Future<bool> logIn(String email, String Password) async {
      try {
         userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: Password,

         );
         userid.value = userCredential.user!.uid;
         print('User id $userid');

         print('User logged in: ${userCredential.user!.email}');
   return true;
      } on FirebaseAuthException catch (e) {
        print('Failed to log in: $e');
        return false;
      }
    }

}
