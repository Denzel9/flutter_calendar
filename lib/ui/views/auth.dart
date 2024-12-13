import 'package:calendar_flutter/service/auth/auth_service_impl.dart';
import 'package:calendar_flutter/service/shared_prefs/shared_prefs.dart';
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
  AuthServiceImpl authService = AuthServiceImpl();
  UserServiceImpl userService = UserServiceImpl();
  final localStorage = LocalStorage();
  final routesList = Routes();
  bool isloading = false;
  bool islogin = true;

  @override
  void initState() {
    // localStorage.deleteItem('id');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose();
  }

  Future loginHandler(BuildContext context) async {
    final store = context.read<AppStore>();
    setState(() {
      isloading = true;
    });
    try {
      await authService.login(login.text, password.text).then((User user) {
        store.setUser(user.uid).then((_) {
          if (context.mounted) {
            // store.user.docId = user.uid;
            localStorage.setItem('id', user.uid);
            Navigator.pushReplacementNamed(context, routesList.home);
          }
        });
      });
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
        isloading = false;
      });
    }
  }

  Future registerHandler(BuildContext context) async {
    setState(() {
      isloading = true;
    });
    try {
      await authService.register(login.text, password.text).then((User user) {
        userService.addUser({
          'name': user.displayName ?? '',
          'lastName': '',
          'email': user.email,
          'followers': [],
          'following': [],
        }, user.uid).then((_) {
          if (context.mounted) {
            userService.setUser(user.uid);
            Navigator.pushReplacementNamed(context, routesList.home);
          }
        });
      });
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
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<AppStore>();

    localStorage.getItem('id').then((id) {
      if (id.isNotEmpty && context.mounted) {
        store.setUser(id).then((_) {
          // store.user.docId = id;
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, routesList.home);
          }
        });
      }
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 51),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DNButton(
                      loading: isloading,
                      title: islogin ? 'Sign In' : 'Sign Up',
                      isPrimary: true,
                      onClick: () {
                        islogin
                            ? loginHandler(context)
                            : registerHandler(context);
                      },
                    ),
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
