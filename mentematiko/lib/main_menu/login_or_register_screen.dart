import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginOrRegister extends StatelessWidget {

  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyButton(
              onPressed: () {
                GoRouter.of(context).go('/loginOrRegister/login');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            MyButton(
              onPressed: () {
                GoRouter.of(context).go('/loginOrRegister/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}