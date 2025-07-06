import 'package:chattappv1/components/user_tile.dart';
import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:chattappv1/services/auth/chat/chatt_service.dart';

import 'package:flutter/material.dart';

class BlockUserPage extends StatelessWidget {
  BlockUserPage({super.key});

  // chat & auth service
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  // show confirm unblock user
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content: const Text("Are you sure want to unblock this user?"),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                //unblock button
                TextButton(
                  onPressed: (){
                    chatService.unblockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User unblocked!"),));
                  },
                  child: const Text("Unblock"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // get current users id
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("BLOCKED USERS"),
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: ChatService().getBlockedUsersStrem(userId),
          builder: (context, snapshot) {
            //errors..
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading.."),
              );
            }
            // loading..
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final blockedUsers=snapshot.data??[];
            // no users
            if(blockedUsers.isEmpty){
              return const Center(child:Text("No blocked users") ,);
            }

            // load complete
            return ListView.builder(
              itemCount: blockedUsers.length,
                itemBuilder: (context,index){
                  final user=blockedUsers[index];
                  return UserTile(
                    text: user["email"],
                    onTap: ()=>_showUnblockBox(context,user['uid']),
                  );

                }
            );
          }),
    );
  }
}
