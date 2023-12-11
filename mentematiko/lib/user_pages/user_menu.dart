import 'package:card/models/role.dart';
import 'package:card/models/user.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserMenu extends StatelessWidget {
  

  const UserMenu({super.key});
  
  
  @override
  Widget build(BuildContext context) {
  User? user;
   final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      user = args['user'];
    }


    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('User Menu'),
          ),
          body: Builder(
            builder: (BuildContext context) {
              if(user?.role == ROLE.arb){
                return AdminUserMenu();
              } else {
                return NormalUserMenu(key: key,user: user);
              }
            },
          ),
        ),
      )
    );
  }
}

/* da rimuovere */
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

  User? user;

  NormalUserMenu({super.key,this.user});

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
          Text(user?.email ?? 'wrong data'),
          Text(user?.cf ?? 'wrong data'),
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