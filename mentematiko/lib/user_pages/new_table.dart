// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:card/models/room_creation.dart';
import 'package:card/models/user.dart';
import 'package:card/services/match_service.dart';
import 'package:card/settings/settings.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateNewTablePage extends StatefulWidget {
  final MatchService matchService;
  final User user;
  const CreateNewTablePage(
      {required Key key, required this.matchService, required this.user})
      : super(key: key);

  @override
  _CreateNewTablePageState createState() => _CreateNewTablePageState();
}

class _CreateNewTablePageState extends State<CreateNewTablePage> {
  final TextEditingController playersController = TextEditingController();
  int _selectedMinutes = 1;
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Table'),
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row
              Row(
                children: [
                  Text('Players:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: playersController,
                      keyboardType: TextInputType.number,
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
              MyButton(
                onPressed: () {
                  int players = int.tryParse(playersController.text) ?? 2;
                  RoomCreation r =
                      RoomCreation(players: players, minutes: _selectedMinutes);
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
            ],
          )),
    );
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
