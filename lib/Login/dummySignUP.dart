import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sbh24/Startup Screens/Grid.dart';
import 'package:sbh24/Login/VerifyEmail.dart';

class DummySignUp extends StatelessWidget {
  const DummySignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                if (ConnectionState == snapshot.connectionState) {
                return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                return const Center(
                child: Text("Something Went Wrong!!"),
                );
                } else if (snapshot.hasData && FirebaseAuth.instance.currentUser!.isAnonymous == false) {
                return const VerifyEmailPage();
                } else {
                return Grid_Country();
                }
                }),
                );
  }
}
