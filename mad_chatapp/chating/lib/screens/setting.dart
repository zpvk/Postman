import 'package:chating/widgets/MybottomBerDemo.dart';
import 'package:chating/widgets/widget.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: iosappBar("Setting"),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Profile',style: TextStyle(),),
            subtitle: Text('Change Profle photo'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Profile'),
            subtitle: Text('Change Profle photo'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Profile'),
            subtitle: Text('Change Profle photo'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Profile'),
            subtitle: Text('Change Profle photo'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {},
          )
        ],
      ),
    );
  }

  
}
