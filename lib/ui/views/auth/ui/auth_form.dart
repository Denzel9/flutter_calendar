import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/user.dart';

class AuthForm extends StatefulWidget {
  final bool islogin;
  const AuthForm({super.key, required this.islogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController login = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController secondPassword = TextEditingController();

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    secondPassword.dispose();
    super.dispose();
  }

  Future loginHandler(AppStore store) async {
    try {
      final user = await authService.login(login.text, password.text);

      Future.wait([
        store.setUser(user.uid),
        localStorage.setItem('id', user.uid),
      ]);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            id: user.uid,
          ),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text(
            error.message.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    } finally {
      setState(() {
        authService.isLoading = false;
      });
    }
  }

  Future registerHandler(AppStore store) async {
    try {
      if (password.text == secondPassword.text) {
        final user = await authService.register(login.text, password.text);

        Future.wait([
          userService.addUser(
              UserModel(
                name: user.displayName ?? '',
                email: user.email ?? '',
                followers: [],
                following: [],
                lastName: '',
                docId: user.uid,
              ).toJson(),
              user.uid),
          store.setUser(user.uid),
          localStorage.setItem('id', user.uid)
        ]);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              id: user.uid,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
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

  @override
  Widget build(BuildContext context) {
    final store = context.read<AppStore>();

    return Column(
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
            controller: login,
          ),
        ),
        DNInput(
          title: 'Password',
          controller: password,
        ),
        if (!widget.islogin)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: DNInput(
              title: 'Again password',
              controller: secondPassword,
            ),
          ),
        if (widget.islogin)
          const SizedBox(
            height: 20,
          ),
        Align(
          alignment: Alignment.centerRight,
          child: DNButton(
            loading: authService.isLoading,
            title: widget.islogin ? 'Sign In' : 'Sign Up',
            isPrimary: true,
            onClick: () => setState(() {
              widget.islogin ? loginHandler(store) : registerHandler(store);
            }),
          ),
        ),
      ],
    );
  }
}
