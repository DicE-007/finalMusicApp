import 'package:flutter/material.dart';
import './auth.dart';
import './pages/authPage.dart';
import './pages/loginResgisterPage.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (_,snapShot){
      if(snapShot.hasData){
        return AuthPage();
      }else{
        return LoginPage();
      }
      },
    );
  }
}
