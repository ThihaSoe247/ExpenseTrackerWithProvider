import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login(String email, String password) async{
    UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> register(String email, String password) async{
    UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }

  Future<void> signOut() async{
    return _auth.signOut();
  }

}
