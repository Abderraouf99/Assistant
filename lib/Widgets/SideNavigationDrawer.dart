import 'package:flutter/material.dart';

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Image(
                image: AssetImage('assets/icon/icon.png'),
              ),
              title: Text(
                'Assistant',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.toc),
              title: Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text(
                'Events',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text(
                'Archive',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded),
              title: Text(
                'Bin',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {},
            ),
            ListTile(),
          ],
        ),
      ),
    );
  }
}
