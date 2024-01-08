import 'package:card/models/role.dart';
import 'package:card/models/user.dart';
import 'package:card/services/login_register_service.dart';
import 'package:card/style/my_button.dart';
import 'package:card/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {

  final LoginService loginService;
  const RegisterPage({required Key key,required this.loginService}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _cf = TextEditingController(); 
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _regione = TextEditingController(); 
  final TextEditingController _provincia = TextEditingController(); 
  final TextEditingController _istituto = TextEditingController(); 
  final TextEditingController _password = TextEditingController(); 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registrazione'),
        ),
        body: ResponsiveScreen(
          squarishMainArea: Center(
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    getGapHeight(context),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cf,
                      decoration: InputDecoration(labelText: 'Codice Fiscale'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your codice fiscale';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nome,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _regione,
                      decoration: InputDecoration(labelText: 'Regione'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your regione';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _provincia,
                      decoration: InputDecoration(labelText: 'Provincia'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Provincia';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _istituto,
                      decoration: InputDecoration(labelText: 'Istituto'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Istituto';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                    ),
                    getGapHeight(context),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                           User u = User(
                             email: _email.text,
                             cf: _cf.text,
                             istituto: _istituto.text,
                             regione: _regione.text,
                             role: ROLE.user,
                             nome: _nome.text,
                             provincia: _provincia.text,
                             password: _password.text
                            );
                            widget.loginService.registration(u);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Registrazione completata')),
                            );
                            GoRouter.of(context).go('/login');
                          }
                        },
                        child: Text('Registrati'),
                      ),
                    )
                  ]))),
          rectangularMenuArea: getGapHeight(context),
        ));
  }

  static SizedBox getGapHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    var padding;
    if (screenHeight > 736) {
      padding = mediaQuery.size.width * 0.03;
    } else {
      padding = mediaQuery.size.width * 0;
    }

    return SizedBox(height: padding);
  }
}
