import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<String> LoginWithEmail(String email, String password) async {
  print(password);
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return "Success";
  } on FirebaseAuthException catch (e) {
    print("error code: " + e.code);
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

Future<bool> CheckLoginState() async {
  User? user = await auth.currentUser;
  if (user != null) {
    return true;
  } else {
    return false;
  }
}

Future<void> Logout() async {
  await auth.signOut();
}
