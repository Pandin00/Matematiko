import 'package:card/models/playable_cards.dart';
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
  Player? player;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  void _loadPlayerData() {
    widget.matchService
        .searchByOrder(widget.idRoom, widget.order)
        .then((value) => {
              setState(() {
                player = value!;
              })
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
        Text('Opponent Name: ${player!.id.split("§")[1]}'),
        ElevatedButton(
          onPressed: () {
            _loadPlayerData();
            showCard(context, player!.cards!);
          },
          child: Text('Show cards'),
        ),
      ],
    );
  }

  void showCard(BuildContext context, List<PlayableCards> cards) {
    int numRows = 3;
    int numCardsPerRow = (cards.length / numRows).ceil();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Carte'),
          children: [
            // display the cards in each row
            for (int i = 0; i < numRows; i++)
              Wrap(
                children: [
                  for (int j = 0; j < numCardsPerRow; j++)
                    if (i * numCardsPerRow + j < cards.length)
                      Container(
                        child: Image.network(
                          cards[i * numCardsPerRow + j].rendering(),
                          height: 110,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                ],
              ),
          ],
        );
      },
    );
  }
}
