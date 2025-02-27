import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/auth/ui/auth_form.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool islogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Stack(
            children: [
              AuthForm(islogin: islogin),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DNText(
                        title: islogin
                            ? "Don't have an account?"
                            : "Alredy a member?",
                      ),
                      GestureDetector(
                        onTap: () => setState(() => islogin = !islogin),
                        child: DNText(
                          title: islogin ? ' Sign Up' : ' Sign In',
                          color: Colors.amberAccent,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
