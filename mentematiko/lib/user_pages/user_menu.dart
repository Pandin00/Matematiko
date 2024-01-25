import 'package:card/models/role.dart';
import 'package:card/models/user.dart';
import 'package:card/services/match_service.dart';
import 'package:card/settings/settings.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserMenu extends StatelessWidget {
  final User user;
  final MatchService matchService;

  const UserMenu(
      {required super.key, required this.user, required this.matchService});

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
              if (user.role == 'ARB') {
                return ArbUserMenu(
                    key: Key('arb'), user: user, matchService: matchService);
              } else {
                return NormalUserMenu(
                    key: key, user: user, matchService: matchService);
              }
            },
          ),
        ),
      ),
    );
  }
}

class ArbUserMenu extends StatelessWidget {
  final User user;
  final MatchService matchService;
  const ArbUserMenu(
      {required super.key, required this.user, required this.matchService});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyButton(
            onPressed: () async {
              final code = await showDialog<String>(
                context: context,
                builder: (BuildContext context) => _EnterGameCode(),
              );

              if (code != null) {
                matchService.joinInGame(code, user).then((value) => {
                      if (value.errorCode != 'NOT_FOUND' && value.errorCode!='FULL'){
                        context.read<SettingsController>().setRoomCode(value.roomId?? ''),
                        context.read<SettingsController>().setMaxPlayer(value.maxPlayers?? -1),
                        GoRouter.of(context).go('/lobby', extra: user)
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Room not found or full"),
                          duration: Duration(seconds: 4),
                        ))
                      }
                    });
              }
            },
            child: Text('Entra in partita'),
          ),
          MyButton(
            onPressed: () {
              GoRouter.of(context).go('/newTable', extra: user);
            },
            child: Text('Crea tavolo'),
          ),
        ],
      ),
    );
  }
}

class NormalUserMenu extends StatelessWidget {
  User user;
  final MatchService matchService;

  NormalUserMenu({super.key, required this.user, required this.matchService});

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
                matchService.joinInGame(code, user).then((value) => {
                      if (value.errorCode != 'NOT_FOUND' && value.errorCode!='FULL'){
                        context.read<SettingsController>().setRoomCode(value.roomId?? ''),
                        context.read<SettingsController>().setMaxPlayer(value.maxPlayers?? -1),
                        GoRouter.of(context).go('/lobby', extra: user)
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Room not found or full"),
                          duration: Duration(seconds: 4),
                        ))
                      }
                    });
              }
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
