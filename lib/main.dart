import 'package:advanced_todo/database/auth_service.dart';
import 'package:advanced_todo/database/model/user/user_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/database/user_database/user_database.dart';
import 'package:advanced_todo/loading.dart';
import 'package:advanced_todo/routes.dart';
import 'package:advanced_todo/state/drawer_state.dart';
import 'package:advanced_todo/views/home_screen/home_screen.dart';
import 'package:advanced_todo/views/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:advanced_todo/theme.dart' as theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Routes.createRoutes();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthService.instance(),
        ),
      ],
      child: AdvancedToDoApp(),
    ),
  );
}

class AdvancedToDoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.instance().getAuth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            home: SafeArea(
              child: Text('Something went wrong ' + snapshot.error.toString()),
            ),
          );
        }
        final User user = snapshot.data;
        if(user != null) {
          return startApp(context, user);
        }
        return LoginScreen();
      },
    );
  }

  Widget startApp(BuildContext context, User user) {
    final UserDatabaseService _userDatabaseService = UserDatabaseService(user);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _userDatabaseService,
        ),
        ChangeNotifierProvider.value(
          value: TodoDatabase(user),
        ),
        ListenableProvider<ATDrawerState>(
          create: (context) => ATDrawerState(),
        )
      ],
      child: MaterialApp(
        title: 'Advanced Todos',
        onGenerateRoute: Routes.sailor.generator(),
        navigatorKey: Routes.sailor.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: theme.myTheme,
        home: FutureBuilder(
          future: _userDatabaseService.getOrCreateUser(),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if(snapshot.hasData && !snapshot.hasError) {
              return HomeScreen();
            }
            return LoadingSpinner();
          },
        ),
      ),
    );
  }
}
