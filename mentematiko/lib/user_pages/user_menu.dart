import 'package:card/models/role.dart';
import 'package:card/models/user.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserMenu extends StatelessWidget {
  final User user;

  const UserMenu({required super.key, required this.user});

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
              if (user.role == ROLE.arb) {
                return AdminUserMenu();
              } else {
                return NormalUserMenu(key: key, user: user);
              }
            },
          ),
        ),
      ),
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
            onPressed: () {},
            child: Text('Aggiungi utente'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/userMenu/usersView');
            },
            child: Text('Lista utenti'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/userMenu/newTournament');
            },
            child: Text('Crea torneo'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/userMenu/tournamentsView');
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

  NormalUserMenu({super.key, this.user});

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
          getGapHeight(context),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/userMenu/play');
            },
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/userMenu/tournamentsView');
            },
            child: Text('Guarda Classifica'),
          ),
        ],
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
