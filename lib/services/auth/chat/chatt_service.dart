import 'package:chattappv1/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier {
  //get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//get all users strem
  Stream<List<Map<String, dynamic>>> getUserStrean() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  //get all users stream excpt blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      // get all users
      final usersSnapshot = await _firestore.collection('Users').get();

      // return as stream list,excludong current user and blocked users
      return usersSnapshot.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currenUserID = _auth.currentUser!.uid;
    final String? currenUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    //create a new message

    Message newMessage = Message(
        senderID: currenUserID,
        senderEmail: currenUserEmail!,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currenUserID, receiverID];
    ids.sort(); //sort the ids (this ensure the chatroomID id the same for any 2 people)
    String chatroomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_room")
        .doc(chatroomID)
        .collection("message")
        .add(newMessage.toMap());
  }

// get messages
  Stream<QuerySnapshot> getMessage(String userID, otheruserID) {
    //construct a chatroom ID for the two users
    List<String> ids = [userID, otheruserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

// report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timetamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }

// BLOCK USER
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

//unblock user
  Future<void> unblockUser(String blockUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('Users')
        .doc(blockUserId)
        .delete();
  }

//get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStrem(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('Users')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('Users').doc(id).get()),
      );
      //return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
