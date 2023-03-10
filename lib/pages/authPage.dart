import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '.././auth.dart';

class AuthPage extends StatelessWidget {

  final User? user = Auth().currentUser;
  Future<void>signOut() async {
    await Auth().signOut();
  }

  Widget _title(){
    return const Text("yay");
  }
  Widget _userId(){
    return  Text( user?.email ?? "yay");
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: Text("SignOut"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title(),),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userId(),
            _signOutButton()
          ],
        ),
      ),
    );
  }
}
