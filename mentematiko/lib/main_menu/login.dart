import 'package:card/main_menu/popup_util.dart';
import 'package:card/services/login_register_service.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final LoginService loginService;

  const LoginPage({super.key, required this.loginService});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final internal = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameText,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordText,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            getGapHeight(context),
            MyButton(
              onPressed: () {
                if (_usernameText.text.isEmpty || _passwordText.text.isEmpty) {
                  PopupUtil.showPopup(
                    context: context,
                    title: 'Errore',
                    content: 'Inserisci username e password',
                  );
                } else {
                  var login = widget.loginService
                      .login(_usernameText.text, _passwordText.text);
                  login.then((value) => {
                        if (value.email.isNotEmpty)
                          {
                            //da risolvere il passaggio  di parametri
                            GoRouter.of(context).go('/userMenu', extra: value)
                          }
                        else
                          PopupUtil.showPopup(
                            context: internal,
                            title: 'Errore',
                            content: 'Login fallito',
                          )
                      });
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  static SizedBox getGapHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    var padding;
    if (screenHeight > 718) {
      padding = mediaQuery.size.width * 0.03;
    } else {
      padding = mediaQuery.size.width * 0;
    }

    return SizedBox(height: padding);
  }
}
