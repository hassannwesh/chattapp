import 'package:chattappv1/Pages/chat_page.dart';
import 'package:chattappv1/components/my_drawer.dart';
import 'package:chattappv1/components/user_tile.dart';
import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:chattappv1/services/auth/chat/chatt_service.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //foregroundColor: Colors.grey,
        elevation: 0,
        foregroundColor: Colors.grey,
        centerTitle: true,
        title: const Text(
          " USERS ",
        ),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStreamExcludingBlocked(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text('error');
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          }
          // return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users excepl current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
          // هنا اسم المستخدم
          text: userData["email"],
          onTap: () {
            //tapped ona user -> go to cgat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}
