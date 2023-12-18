import 'package:card/style/my_button.dart';
import 'package:flutter/material.dart';

class CreateNewTablePage extends StatefulWidget {
  @override
  _CreateNewTablePageState createState() => _CreateNewTablePageState();
}

class _CreateNewTablePageState extends State<CreateNewTablePage> {
  List<bool> selectedTeams = List.generate(8, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Table'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                 return _CheckboxItem(
                    title: 'Team ${index + 1}',
                    value: selectedTeams[index],
                    onChanged: (bool? newValue) {
                      setState(() {
                        selectedTeams[index] = newValue ?? false;
                      });
                    },
                 );
                },
              ),
            ),
            MyButton(
              onPressed: () {
                // TODO: Save the table with the selected teams
              },
              child: Text('Create Table'),
            ),
          ],
        ),
      ),
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