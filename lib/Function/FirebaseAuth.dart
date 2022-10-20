import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<String> LoginWithEmail(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return "Success";
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}

Future<String> RegisterWithEmail(String email, String password) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(userCredential);
    return "Success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('weak-password');
    } else if (e.code == 'email-already-in-use') {
      print('email-already-in-use');
    }
  } catch (e) {
    print(e);
  }
  return "Failed";
}
