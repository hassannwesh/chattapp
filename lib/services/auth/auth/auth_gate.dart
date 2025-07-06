import 'package:chattappv1/services/auth/login%20or%20register%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Pages/homepage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context,snapshot){
            // user is logged in
            if(snapshot.hasData){
              return  Homepage();
            }
            // user on not logged in
            else{
              return const login_or_register();
            }
          }
      ),
    );
  }
}
