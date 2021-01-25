import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/addNote.dart';
import 'file:///C:/Users/abder/Documents/Assistant/lib/Widgets/NotesList/NotesList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/constants.dart';

class NoteScreen extends StatefulWidget {
  static String noteScreenID = "NoteScreenID";

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  Widget _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: AddNote(),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageHeader(
          pageName: 'Notes',
        ),
      ),
      drawer: DrawerCustom(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: _buildBottomSheet,
              isScrollControlled: true);
        },
        elevation: 3,
        child: Icon(
          Icons.add,
          color: Color(0xffEEEEEE),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: NoteList(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: kRoundedContainerDecorator.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
