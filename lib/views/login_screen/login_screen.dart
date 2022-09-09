import 'package:advanced_todo/database/auth_service.dart';
import 'package:advanced_todo/widgets/buttons/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Scaffold(
        body: this.buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context, listen: false);
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome! Please sign in!",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text('or'),
              SizedBox(
                height: 40,
              ),
              ATLoginButton(
                'Login with Google',
                () => _authService.signInWithGoogle(),
              )
            ],
          ),
        ),
      );
    });
  }
}
