import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class description_profile extends StatefulWidget {
  @override
  _description_profileState createState() => _description_profileState();
}

class _description_profileState extends State<description_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description/Type'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CardSettings.sectioned(

          children: [
            CardSettingsSection(
              children: [
                CardSettingsParagraph(
                  label: "Description",
                  style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize),
                  hintText: 'Please enter some text',
                ),
              ],
            ),
            CardSettingsSection(
              children: <CardSettingsWidget> [
                CardSettingsText(
                  label: "Type",
                  hintText: "Please enter  the type",

                ),
              ],
            ),
            CardSettingsSection(
              children: [
                CardSettingsButton(
                  label: 'Save',
                  backgroundColor: Colors.greenAccent,
                  onPressed: () {},
                ),
              ],
            ),
            CardSettingsSection(
              children: [
                CardSettingsButton(
                  label: 'Cancel',
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
