import 'package:chattappv1/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'BlockUserPage.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Setting",
        ),
      ),
      body: Column(
        children: [
          // dark mode button
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.only(left: 25,right: 25,top:25,bottom: 20),

            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dark Mode
                const Text("Dark Mode",style: TextStyle(fontSize: 20),),
                // Switch toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) => CupertinoSwitch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
              ],
            ),
          ),
          // bloced users button
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.only(left: 25,right: 25,top: 5,bottom: 5),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Blocked Users
                const Text("Blocked Users",style: TextStyle(fontSize: 20),),
                // button to go blocked user page
                IconButton(
                    onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=> BlockUserPage())),
                    icon:  Icon(
                      Icons.arrow_forward_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
