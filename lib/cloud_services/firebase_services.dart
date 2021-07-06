import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore database = FirebaseFirestore.instance;

  //Login with existing username and password credential
  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  //Login with google credential
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  //Register and store new user information
  Future<bool> signUp(String firstName, String lastName, String email, String password) async {
    try {
      await _signUpHelper(
        email.trim(),
        password.trim(),
      ).then((value) async {
        User? user = _auth.currentUser;
        await database.collection("users").doc(user!.uid).set(
            {
              'user_id': user.uid.trim(),
              'first_name': firstName.trim(),
              'last_name':  lastName.trim(),
              'email': email.trim(),
              'user_role': 'customer'.trim(),
              'reg_date_time': user.metadata.creationTime
            });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Register new user with user name and password
  Future<void> _signUpHelper(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //Signing user out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
