import 'package:chattappv1/Pages/SettingPage.dart';
import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(){
    // get auth service
    final auth=AuthService();
    auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      // logo
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 45,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    title: const Text('H O M E'),
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      //go to home page
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: ListTile(
                    title: const Text('S T T I N G S'),
                    leading: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25),
              child: ListTile(
                title: const Text('L O G O U T'),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: logout,
              ),
            )

            // home list tile
            //setting list tile
            //logout list tile
          ],
        ));
  }
}
