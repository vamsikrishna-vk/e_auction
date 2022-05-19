import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String? email, String? password}) async {
    try {
      Fluttertoast.showToast(
        msg: "Logging in please wait!",
      );
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
        msg: "Login Successfull",
      );
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print('prob');
      Fluttertoast.showToast(
        msg: "invaild details try again!",
      );
      return e.message;
    }
  }

  Future<String> signUp(
      {String? email, String? password, BuildContext? context}) async {
    try {
      Fluttertoast.showToast(
        msg: "Registration in process please wait",
      );
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Fluttertoast.showToast(
        msg: "Registerd Succesfully Login to continue",
      );
      Navigator.pop(context!);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "invaild details try again!",
      );

      return e.message;
    }
  }
}
