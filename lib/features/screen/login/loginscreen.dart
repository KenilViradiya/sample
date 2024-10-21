import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiplayer/features/screen/gamescreen/game_screen.dart';
import 'package:multiplayer/features/screen/login/controller.dart';
import 'package:multiplayer/features/screen/mainscreen/mainscreen.dart';


class LoginScreen extends StatelessWidget {
  final Login_controller loginController = Get.put(Login_controller());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth with GetX'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Password Input
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),

            // Sign Up Button
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                if(await loginController.signUp(email, password)) {
                  Get.to(Main_Screen());
                }
                else
                  {
                    print('error in signup');
                  }
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 10),

            // Log In Button
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
               if( await loginController.logIn(email, password)){
                Get.to(Main_Screen());
              }
               else
                 {
                   print('error in login');
                 }
                 },
              child: Text('Log In'),
            ),

            SizedBox(height: 20),

            // Displaying User ID
            Obx(() {
              return Text(
                'User ID: ${loginController.userid.value}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              );
            }),
          ],
        ),
      ),
    );
  }
}
