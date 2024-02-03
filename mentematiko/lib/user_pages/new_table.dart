// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:card/models/room_creation.dart';
import 'package:card/models/user.dart';
import 'package:card/services/match_service.dart';
import 'package:card/settings/settings.dart';
import 'package:card/style/my_button.dart';
import 'package:card/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateNewTablePage extends StatefulWidget {
  final MatchService matchService;
  final User user;

  const CreateNewTablePage({
    required Key key,
    required this.matchService,
    required this.user,
  }) : super(key: key);

  @override
  _CreateNewTablePageState createState() => _CreateNewTablePageState();
}

class _CreateNewTablePageState extends State<CreateNewTablePage> {
  final TextEditingController playersController = TextEditingController();
  int _selectedMinutes = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Table'),
      ),
  body: Center (
  child: ResponsiveScreen(
    squarishMainArea: Center(
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Row(
              children: [
                Text('Players:'),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: playersController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'max 6 players',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Third Row
            Row(
              children: [
                Text('Time:'),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (value) {
                      _selectedMinutes = int.tryParse(value) ?? 1;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter minutes (1-60)',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: MyButton(
                onPressed: () {
                  int players = int.tryParse(playersController.text) ?? 2;
                  if (players < 1 || players > 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid number of players'),
                      ),
                    );
                    return;
                  }
                  if (_selectedMinutes < 1 || _selectedMinutes > 60) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid time (1-60 minutes)'),
                      ),
                    );
                    return;
                  }
                  RoomCreation r = RoomCreation(players: players, minutes: _selectedMinutes);
                  context
                      .read<SettingsController>()
                      .setTimePerTurn(_selectedMinutes);

                  widget.matchService
                      .createRoom(r, widget.user)
                      .then((value) => {
                            if (value.isNotEmpty)
                              {
                                context
                                    .read<SettingsController>()
                                    .setRoomCode(value[0]),
                                context
                                    .read<SettingsController>()
                                    .setMaxPlayer(r.players),
                              }
                          })
                      .whenComplete(() => GoRouter.of(context)
                          .go('/lobby', extra: widget.user));
                },
                child: Text('Create Table'),
              ),
            ),
          ],),
        ),
    ),
    rectangularMenuArea: getGapHeight(context),
  ),
  ),
);
  }
  
  static SizedBox getGapHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    var padding;
    if (screenHeight > 736) {
      padding = mediaQuery.size.width * 0.03;
    } else {
      padding = mediaQuery.size.width * 0;
    }

    return SizedBox(height: padding);
  }
}

class _CheckboxItem extends StatefulWidget {
  const _CheckboxItem({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  _CheckboxItemState createState() => _CheckboxItemState();
}

class _CheckboxItemState extends State<_CheckboxItem> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
