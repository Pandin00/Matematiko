import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});
  //chiamata BE per prendere dati utente
  static const isAdmin = true;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('User Menu'),
          ),
          body: Builder(
            builder: (BuildContext context) {
              if(isAdmin){
                return AdminUserMenu();
              } else {
                return NormalUserMenu();
              }
            },
          ),
        ),
      )
    );
  }
}

class AdminUserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyButton(
            onPressed: () {
            },
            child: Text('Aggiungi utente'),
          ),
          MyButton(
            onPressed: () {},
            child: Text('Lista utenti'),
          ),
          MyButton(
            onPressed: () {},
            child: Text('Crea torneo'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/loginOrRegister/tournamentsView');
            },
            child: Text('Visualizza tornei'),
          ),
          MyButton(
            onPressed: () {},
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {},
            child: Text('Guarda Partita'),
          ),
        ],
      ),
    );
  }
}

class NormalUserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/image.jpg'),
            radius: 50,
          ),
          Text('Username'),
          _gap,
          MyButton(
            onPressed: () {},
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/loginOrRegister/tournamentsView');
            },
            child: Text('Guarda Classifica'),
          ),
        ],
      ),
    );
  }
  
  static const _gap = SizedBox(height: 120);
}