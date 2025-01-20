import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/auth/auth_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController secondPassword = TextEditingController();
  AuthServiceImpl authService = AuthServiceImpl();
  UserServiceImpl userService = UserServiceImpl();
  bool islogin = true;

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    secondPassword.dispose();
    super.dispose();
  }

  Future loginHandler(AppStore store) async {
    try {
      await authService.login(login.text, password.text).then((User user) {
        store.setUser(user.uid).then((_) {
          if (mounted) {
            localStorage.setItem('id', user.uid);
            Navigator.pushReplacementNamed(context, routesList.home);
          }
        });
      });
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amberAccent,
            content: Text(
              error.message.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        authService.isLoading = false;
      });
    }
  }

  Future registerHandler(BuildContext context) async {
    try {
      if (password.text == secondPassword.text) {
        await authService.register(login.text, password.text).then((User user) {
          userService.addUser({
            'name': user.displayName ?? '',
            'lastName': '',
            'email': user.email,
            'followers': [],
            'following': [],
            'docId': user.uid
          }, user.uid).then((_) {
            if (context.mounted) {
              userService.setUser(user.uid);
              localStorage.setItem('id', user.uid);
              Navigator.pushReplacementNamed(context, routesList.home);
            }
          });
        });
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.amberAccent,
            content: Text(
              "Passwords don't match",
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.amberAccent,
            content: Text(
              error.message.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        authService.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<AppStore>();
    localStorage.getItem('id').then((id) {
      if (id.isNotEmpty && context.mounted) {
        store.setUser(id).then((_) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, routesList.home);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const DNText(
                  title: 'DNTask',
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                  fontSize: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DNInput(
                    title: 'Login',
                    onClick: (value) => login.text = value,
                  ),
                ),
                DNInput(
                  title: 'Password',
                  onClick: (value) => password.text = value,
                ),
                if (!islogin)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: DNInput(
                      title: 'Again password',
                      onClick: (value) => secondPassword.text = value,
                    ),
                  ),
                if (islogin)
                  const SizedBox(
                    height: 20,
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: DNButton(
                    loading: authService.isLoading,
                    title: islogin ? 'Sign In' : 'Sign Up',
                    isPrimary: true,
                    onClick: () {
                      setState(() {
                        islogin
                            ? loginHandler(store)
                            : registerHandler(context);
                      });
                    },
                  ),
                ),
              ],
            ),
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
                      onTap: () => setState(() {
                        islogin = !islogin;
                      }),
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
    );
  }
}
