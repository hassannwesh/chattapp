import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_texefield.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key, required this.onTap});

  // Email and password controllers
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();

  // Tap to go to register page
  final void Function()? onTap;

  // Register method
  void register(BuildContext context) {
    // Get auth service
    final auth = AuthService();
    // Password match -> create user
    if (_passwordcontroller.text == _confirmpasswordcontroller.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailcontroller.text,
          _passwordcontroller.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      // Password don't match -> tell user to fix
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords don\'t match!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.message_outlined,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),

            // Welcome message
            const SizedBox(height: 80),
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            // Email text field
            MyTexefield(
              hintText: 'Email',
              obscureText: false,
              controller: _emailcontroller,
            ),
            const SizedBox(height: 10),

            // Password text field
            MyTexefield(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordcontroller,
            ),
            const SizedBox(height: 10),

            // Confirm password text field
            MyTexefield(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmpasswordcontroller,
            ),

            const SizedBox(height: 25),

            // Register button
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),

            // Register now
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
