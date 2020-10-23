import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

class teamName extends StatefulWidget {
  @override
  _teamNameState createState() => _teamNameState();
}

class _teamNameState extends State<teamName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team name'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: CardSettings.sectioned(
            children: <CardSettingsSection>[
              CardSettingsSection(
                  header: CardSettingsHeader(
                    label: 'Team Name',
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      label: 'Name of the Team',
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Title is required.';
                      },
                    ),
                    CardSettingsText(
                      label: 'Team Admin Name',
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Field is required';
                      },
                    ),
                    CardSettingsNumberPicker(
                      label: 'Number of Team members',
                      min: 1,
                      max: 100,
                    ),
                    CardSettingsButton(
                      label: 'Save',
                      backgroundColor: Colors.greenAccent,
                      onPressed: () {},
                    ),
                    CardSettingsButton(
                      label: 'Cancel',
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
