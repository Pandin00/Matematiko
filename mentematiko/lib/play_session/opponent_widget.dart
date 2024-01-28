import 'package:card/models/player.dart';
import 'package:card/services/match_service.dart';
import 'package:flutter/material.dart';

class OpponentWidget extends StatefulWidget {
  final int order;
  final String idRoom;
  final MatchService matchService;

  const OpponentWidget({
    Key? key,
    required this.matchService,
    required this.order,
    required this.idRoom,
  }) : super(key: key);

  @override
  _OpponentWidgetState createState() => _OpponentWidgetState();
}

class _OpponentWidgetState extends State<OpponentWidget> {
  late Player player;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    final value = await widget.matchService.searchByOrder(widget.idRoom, widget.order);
    setState(() {
      player = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          // Use player data here, for example, player.profilePic
          backgroundImage: AssetImage('assets/profile_pic.jpg'),
        ),
        const SizedBox(
            width: 16), // Aggiunge uno spazio tra il cerchio e il testo
        Text('Opponent Name: ${player.id.split("§")[1]}'),
        ElevatedButton(
          onPressed: () {
            //print('Show cards');
          },
          child: Text('Show cards'),
        ),
      ],
    );
  }
}

