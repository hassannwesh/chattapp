
import 'package:flutter/cupertino.dart';
import '../../Pages/RegisterPage.dart';
import '../../Pages/loginpage.dart';

class login_or_register extends StatefulWidget {
  const login_or_register({super.key});

  @override
  State<login_or_register> createState() => _login_or_registerState();
}

class _login_or_registerState extends State<login_or_register> {
  //initially, show login page
  bool showLoginPage=true;
  //toggle between login and register page
  void togglepages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
   if(showLoginPage){
     return Loginpage(
       onTap: togglepages,
     );
   }else{
     return Registerpage(
       onTap: togglepages,
     );
   }
  }
}
