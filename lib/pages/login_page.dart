import 'package:flutter/material.dart';
import 'package:ocr_2/auth/auth_service.dart';
import '../provider/auth_provider.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('Login Failed'),
      //     content: Text(e.toString()),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Image.asset(
                    'assets/images/ocd.png',
                    color: Colors.brown,
                    width: 150,
                    height: 150,
                  ),

            const SizedBox(height: 20,),

            Text(
              "Welcome back! You've been missed",
              style: TextStyle(
                // color: Colors.grey[800],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25,),

            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10,),

            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20,),

            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),

            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member?  "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now!', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ],
            ),

            const SizedBox(height: 20,),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //         onPressed: () => AuthService().signInWithGoogle(), 
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Theme.of(context).colorScheme.secondary,
          //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30),
          //             side: BorderSide(color: Colors.grey.shade300),
          //           ),
          //           elevation: 2,
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Image.asset(
          //               'assets/images/google_logo.png',
          //               height: 44,
          //             ),
          //             // const SizedBox(width: 10),
          //             // const Text(
          //             //   'Sign in with Google',
          //             //   style: TextStyle(
          //             //     color: Colors.black,
          //             //     fontSize: 16,
          //             //     fontWeight: FontWeight.w500,
          //             //   ),
          //             // ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       ElevatedButton(
          //         onPressed: () => AuthService().signInWithGoogle(), 
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Theme.of(context).colorScheme.secondary,
          //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(30),
          //             side: BorderSide(color: Colors.grey.shade300),
          //           ),
          //           elevation: 2,
          //         ),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Image.asset(
          //               'assets/images/apple_logo2.png',
          //               height: 44,
          //             ),
          //             // const SizedBox(width: 10),
          //             // const Text(
          //             //   'Sign in with Google',
          //             //   style: TextStyle(
          //             //     color: Colors.black,
          //             //     fontSize: 16,
          //             //     fontWeight: FontWeight.w500,
          //             //   ),
          //             // ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   )
           ],
        ),
      ),
    );  
  }
}
