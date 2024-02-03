import 'package:card/models/user.dart';
import 'package:card/services/login_register_service.dart';
import 'package:card/style/my_button.dart';
import 'package:card/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  final LoginService loginService;
  const RegisterPage({required Key key, required this.loginService}) : super(key: key);

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
  

Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height * 0.6;

    bool isValidEmail(String email) {
      return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
    }

    bool isValidCF(String cf) {
      return RegExp(r'^[A-Z]{6}[0-9LMNPQRSTUV]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$').hasMatch(cf);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrazione'),
      ),
      body: ResponsiveScreen(
        squarishMainArea: Align(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: screenHeight * 0.05),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!isValidEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cf,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Codice Fiscale'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your codice fiscale';
                    } else if  (!isValidCF(value)) {
                      return 'Inserire un codice fiscale valido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nome,
                  keyboardType: TextInputType.text,
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
                  keyboardType: TextInputType.text,
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
                  keyboardType: TextInputType.text,
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
                  keyboardType: TextInputType.text,
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
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
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
                          role: 'user',
                          nome: _nome.text,
                          provincia: _provincia.text,
                          password: _password.text,
                        );
                        widget.loginService.registration(u);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registrazione completata'),
                          ),
                        );
                        GoRouter.of(context).go('/login');
                      }
                    },
                    child: Text('Registrati'),
                  ),
                ),
              ],
            ),
          ),
        ),
        rectangularMenuArea: SizedBox(height: screenHeight * 0.05),
      ),
    );
  }
}
