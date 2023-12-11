import 'package:card/style/my_button.dart';
import 'package:card/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    _gap,
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Codice Fiscale'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your codice fiscale';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your nome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Regione'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your cognome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Provincia'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your cognome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Istituto'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your cognome';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your cognome';
                        }
                        return null;
                      },
                    ),
                    _gap,
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: MyButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Registrazione completata')),
                            );
                            GoRouter.of(context).go('/userMenu');
                          }
                        },
                        child: Text('Registrati'),
                      ),
                    )
                  ]))),
          rectangularMenuArea: _gap,
        ));
  }

  static const _gap = SizedBox(height: 100);
}
