import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewTournamentPage extends StatefulWidget {
  @override
  _NewTournamentPageState createState() => _NewTournamentPageState();
}

num squadNumber = 0;
final String _fiscalCodePattern = '^[A-Z]{6}\d{2}[A-Z]\d{3}[A-Z]';

class _NewTournamentPageState extends State<NewTournamentPage> {
  // Create variables for tournament name and squads
  String _tournamentName = '';
  List<_Squad> _squads = [];

  // Define a function to handle adding a squad
  void _addSquad() {
    setState(() {
      _squads.add(_Squad());
    });
  }

  // Define a function to handle form submission
  void _submitForm() {
    // Perform necessary actions like validation, data submission etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tournament'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add a TextFormField for tournament name
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome Torneo'),
                onChanged: (value) {
                  _tournamentName = value;
                },
              ),
              // Add a list of _SquadForm to represent the squads
              for (_Squad squad in _squads)
                _SquadForm(squad: squad, key: UniqueKey()),

              // Add a FloatingActionButton to add a squad
              FloatingActionButton(
                onPressed: _addSquad,
                child: Icon(Icons.add),
              ),

              // Add a RaisedButton to submit the form
              MyButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Squad {
  String playerCode1 = '';
  String playerCode2 = '';
}

class _SquadForm extends StatefulWidget {
  final _Squad squad;

  _SquadForm({required Key key, required this.squad}) : super(key: key);

  @override
  __SquadFormState createState() => __SquadFormState();
}

class __SquadFormState extends State<_SquadForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getGapHeight(context),
        Text('Squadra'),
        // Add TextFormFields for player codes
        TextFormField(
          decoration: InputDecoration(labelText: 'Codice Fiscale 1'),
          onChanged: (value) {
            setState(() {
              widget.squad.playerCode1 = value;
            });
          },
          validator: (value) {
            if (!RegExp(_fiscalCodePattern).hasMatch(value!)) {
              return 'Invalid fiscal code';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Codice Fiscale 2'),
          onChanged: (value) {
            setState(() {
              widget.squad.playerCode2 = value;
            });
          },
          validator: (value) {
            if (!RegExp(_fiscalCodePattern).hasMatch(value!)) {
              return 'Invalid fiscal code';
            }
            return null;
          },
        ),
      ],
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
