import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '.././auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage= "";
  bool isLogin = true;
  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();
  Future<void> signInWithEmailAndPassword() async{
    try{
      await Auth().signInWithEmailAndPassword(email: _controlleremail.text, password: _controllerpassword.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  Future<void> createUserWithEmailAndPassword() async{
    try{
      await Auth().createUserWithEmailAndPassword(email: _controlleremail.text, password: _controllerpassword.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return Text("FirebaseAuth");
  }
   Widget _entryField(
       String title,TextEditingController controller
       ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText:  title
      ),
    );
   }

   Widget _errorMsg(){
    return Text(errorMessage =="" ? "":"Humm ? ${errorMessage}");
   }

   Widget _submitButton(){
    return ElevatedButton(onPressed: isLogin?signInWithEmailAndPassword:createUserWithEmailAndPassword,
        child: Text(isLogin ? "login":  "register"));
   }

   Widget _loginRegisterButton(){
      return TextButton(onPressed:(){
        setState(() {
          isLogin = !isLogin;
        });
      }, child: Text(isLogin?"Register Instead":"Login Instead"));
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _entryField("email", _controlleremail),
            _entryField("password", _controllerpassword),
            _errorMsg(),
            _submitButton(),
            _loginRegisterButton(),
          ],
        ),
      ),
    );
  }
}
