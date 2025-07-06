import 'package:chattappv1/components/chat_buble.dart';
import 'package:chattappv1/components/my_texefield.dart';
import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:chattappv1/services/auth/chat/chatt_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messagecontroller = TextEditingController();
  //chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for textfield
  FocusNode myfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //add listener to focus node
    myfocusNode.addListener(() {
      if (myfocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    //wait a bit for listview to be built, then scroll to bottun
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myfocusNode.dispose();
    _messagecontroller.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMassege() async {
    // if there id something inside the textfield
    if (_messagecontroller.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
          widget.receiverID, _messagecontroller.text);

      //clear text controller
      _messagecontroller.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          //display all message
          Expanded(
            child: _builMessagelist(),
          ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _builMessagelist() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text("error");
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading..");
          }

          // return list viwe
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _builMessageItem(doc))
                .toList(),
          );
        });
  }

// build message item
  Widget _builMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    // align Message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data["senderID"],
          )
        ],
      ),
    );
  }

//buil message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          //  textfield should take up most of the space
          Expanded(
            child: MyTexefield(
                hintText: "Type a message",
                obscureText: false,
                focusNode: myfocusNode,
                controller: _messagecontroller),
          ),
          // send button

          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMassege,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
