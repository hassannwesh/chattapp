import 'package:chattappv1/services/auth/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_texefield.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key, required this.onTap});

  //email and pw controller
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

//tap tp go to register page
  final void Function()? onTap;

  // login method
  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();
    //try login
    try {
      await authService.signInWithEmailPassword(
        _emailcontroller.text,
        _passwordcontroller.text,
      );
    }
    // catch error
    catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  e.toString(),
                ),
              ));
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
            //logo
            Icon(
              Icons.message_outlined,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),

            //welocme back message
            const SizedBox(
              height: 80,
            ),
            Text(
              'Welcome back, We missed you!!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            //email textfiled
            MyTexefield(
              hintText: 'Email',
              obscureText: false,
              controller: _emailcontroller,
            ),
            const SizedBox(
              height: 10,
            ),
            //pw textfiled
            MyTexefield(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordcontroller,
            ),

            const SizedBox(
              height: 25,
            ),
            //login button
            MyButton(
              text: 'LOG IN',
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 25,
            ),

            //register now
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
