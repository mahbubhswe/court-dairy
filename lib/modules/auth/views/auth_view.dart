// ignore_for_file: depend_on_referenced_packages
import 'package:courtdiary/modules/layout/views/layout_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_auth_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  const LayoutView();
        } else {
          return GoogleAuthView();
        }
      },
    ));
  }
}
