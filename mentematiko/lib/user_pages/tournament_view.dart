import 'package:card/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TournamentsView extends StatelessWidget {
  const TournamentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: TournamentsPage(),
    );
  }
}

class TournamentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> tournaments = [
    {"Punti": 10, "Squadra": "Squadra 1", "Istituto": "Istituto 1"},
    {"Punti": 8, "Squadra": "Squadra 2", "Istituto": "Istituto 2"},
    {"Punti": 6, "Squadra": "Squadra 3", "Istituto": "Istituto 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classifica'),
      ),
      body: ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${tournaments[index]['Squadra']}'),
            subtitle: Text(
                'Punti: ${tournaments[index]['Punti']} - Istituto: ${tournaments[index]['Istituto']}'),
          );
        },
      ),
    );
  }
}