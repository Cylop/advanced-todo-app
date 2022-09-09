import 'package:advanced_todo/database/auth_service.dart';
import 'package:advanced_todo/database/model/user/user_model.dart';
import 'package:advanced_todo/database/user_database/user_database.dart';
import 'package:advanced_todo/widgets/drawer/drawer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave_drawer/wave_drawer.dart';

import '../../routes.dart';

class ATDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    final UserDatabaseService _userDatabase =
        Provider.of<UserDatabaseService>(context, listen: false);
    final UserModel user = _userDatabase.getUser;

    return WaveDrawer(
      backgroundColor: Colors.grey[850],
      boundaryColor: Colors.teal[200],
      boundaryWidth: 0,
      elevation: 10,
      backgroundColorOpacity: 1,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding:
                      const EdgeInsetsDirectional.only(top: 16.0, start: 16.0, bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(end: 5.0),
                              child: Stack(
                                children: [
                                  Semantics(
                                    explicitChildNodes: true,
                                    child: SizedBox(
                                      width: 72.0,
                                      height: 72.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey.withOpacity(0.1), spreadRadius: 5)],
                                        ),
                                        child: CircleAvatar(
                                          child: (user.photoURL == null || user.photoURL.isEmpty
                                              ? Text(user.initials ?? '')
                                              : null),
                                          backgroundImage:
                                          Image.network(user.photoURL ?? 'google.at').image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text('Admin'),
                        Text('@NoSleep'),
                        //Text(user.email ?? 'Unknown'),
                        //Text((user.firstName ?? '') + ' ' + (user.lastName ?? '')),
                      ],
                    ),
                  ),
                ),
                ATDrawerListTile(
                  drawerId: 'dashboard',
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  autoClose: true,
                  onTap: () => Routes.navigateToHome(),
                ),
                ATDrawerListTile(
                  leading: Icon(Icons.list),
                  title: Text('Your Todo Lists'),
                  drawerId: 'all-todo-lists',
                  autoClose: true,
                  onTap: () => Routes.navigateToTodoLists(),
                ),
              ],
            ),
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ATDrawerListTile(
                      drawerId: 'settings',
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () => {},
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () async {
                        await authService.signOutGoogle();
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
