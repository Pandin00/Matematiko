import 'package:flutter/material.dart';

class OpponentWidget extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return Column(
    children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_pic.jpg'),
          ),
          const SizedBox(width: 16), // Aggiunge uno spazio tra il cerchio e il testo
          Text('Opponent Name'),
      ElevatedButton(
        onPressed: () {
          print('Show cards');
        },
        child: Text('Show cards'),
      ),
    ],
  );
}
}