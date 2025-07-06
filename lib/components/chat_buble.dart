import 'package:chattappv1/services/auth/chat/chatt_service.dart';
import 'package:chattappv1/themes/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId});

  //show options
  void _showoptions(BuildContext context, String message, String uderId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              //report message button
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  _reportContent(context, messageId, uderId);
                },
              ),
              //block user button
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text("Block User"),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, uderId);
                },
              ),

              //cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),

              ),
            ],
          ),
        );
      },
    );
  }

  //report messag
  void _reportContent(BuildContext context, String mesageId, String userId) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Report Message"),
              content:
              const Text("Are you sure you want to report this message?"),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                //report button
                TextButton(
                  onPressed: () {
                    ChatService().reportUser(mesageId, userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message Reported"))
                    );
                  },
                  child: const Text("Report"),
                ),
              ],
            ));
  }

  //block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text("Block User"),
              content:
              const Text("Are you sure you want to block this user?"),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                //block button
                TextButton(
                  onPressed: () {
                    ChatService().blockUser(userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked"))
                    );
                  },
                  child: const Text("Block"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //light vs dark mode for correct bubble colors
    bool isDarkMode =
        Provider
            .of<ThemeProvider>(context, listen: false)
            .isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showoptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
              color: isCurrentUser
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
