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
                return AdminUserMenu(key: key, user: user);
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
  User? user;

  AdminUserMenu({super.key, this.user});

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
              GoRouter.of(context).go('/usersView');
            },
            child: Text('Lista utenti'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/newTournament');
            },
            child: Text('Crea torneo'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/tournamentsView');
            },
            child: Text('Visualizza tornei'),
          ),
          MyButton(
            onPressed: () async {
              final code = await showDialog<String>(
                context: context,
                builder: (BuildContext context) => _EnterGameCode(),
              );

              if (code != null) {
                // Check if the game code exists and go to /play if it does
                GoRouter.of(context).go('/play', extra: user);
              }
            },
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/tournamentsView');
            },
            child: Text('Guarda Classifica'),
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
            onPressed: () async {
              final code = await showDialog<String>(
                context: context,
                builder: (BuildContext context) => _EnterGameCode(),
              );

              if (code != null) {
                // Check if the game code exists and go to /play if it does
                GoRouter.of(context).go('/lobby', extra: user);
              }
            },
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/tournamentsView');
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

class _EnterGameCode extends StatefulWidget {
  @override
  __EnterGameCodeState createState() => __EnterGameCodeState();
}

class __EnterGameCodeState extends State<_EnterGameCode> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Inserisci il codice della partita'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Codice'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
          child: Text('Invia'),
        ),
      ],
    );
  }
}