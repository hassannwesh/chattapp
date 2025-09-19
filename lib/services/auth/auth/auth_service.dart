import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user info only if it doesn't already exist
      DocumentReference userDoc =
          _firestore.collection("Users").doc(userCredential.user!.uid);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        await userDoc.set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //create user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //save user info in a separate doc (this will only run once for new users)
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Clean up duplicate users in Firestore (keep only authenticated users)
  Future<void> cleanupDuplicateUsers() async {
    try {
      // Get all users from Firestore
      QuerySnapshot firestoreUsers = await _firestore.collection("Users").get();

      print("Found ${firestoreUsers.docs.length} users in Firestore");

      // List of valid authenticated users (you can modify this list)
      List<String> validEmails = [
        'hosam100@gmail.com',
        'hassan100@gmail.com',
      ];

      // Delete users that are not in the valid list
      for (var doc in firestoreUsers.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        String email = data?['email'] ?? '';
        if (!validEmails.contains(email)) {
          print("Deleting user: $email");
          await doc.reference.delete();
        } else {
          print("Keeping user: $email");
        }
      }

      print("Cleanup completed!");
    } catch (e) {
      print("Error cleaning up users: $e");
    }
  }
// errors
}
