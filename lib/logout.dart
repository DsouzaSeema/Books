import 'package:book/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogOut extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_LogOut();

}

class _LogOut extends State<LogOut>{
  final firebaseAuth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Logged Out :(",style: TextStyle(fontSize: 35,color: Colors.black54,fontWeight: FontWeight.w500),),
              SizedBox(height: 21,),
              ElevatedButton(onPressed: (){
                logout(context);
              }
              , child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
  void logout(BuildContext context) async{
    await firebaseAuth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));

  }
}