// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:card/models/room.dart';
import 'package:card/services/match_service.dart';
import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';

class CreateNewTablePage extends StatefulWidget {


  final MatchService matchService;
  const CreateNewTablePage({required Key key,required this.matchService}) : super(key: key);

  @override
  _CreateNewTablePageState createState() => _CreateNewTablePageState();
}

class _CreateNewTablePageState extends State<CreateNewTablePage> {
  final TextEditingController playersController = TextEditingController();
  int _teams = 2;
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
              // Second Row
              Row(
                children: [
                  Text('Teams :'),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedItem,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedItem = value; // Update selected value
                        });
                        _teams = int.parse(value ?? '2');
                        // Handle dropdown value change
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '2',
                          child: Text('2'),
                        ),
                        DropdownMenuItem<String>(
                          value: '3',
                          child: Text('3'),
                        ),
                        DropdownMenuItem<String>(
                          value: '4',
                          child: Text('4'),
                        ),
                        DropdownMenuItem<String>(
                          value: '5',
                          child: Text('5'),
                        ),
                        // Add more DropdownMenuItem widgets as needed
                      ],
                      hint: Text('Select an option'),
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
                 int players=int.tryParse( playersController.text) ?? 2;
                 Room r=Room(players: players, teams: _teams, minutes: _selectedMinutes);
                 widget.matchService.createRooom(r).then((value) => {
                   //pagina di loading 
                   //redirect 
                 });

                 //invoke service to create room
                  //create room
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
