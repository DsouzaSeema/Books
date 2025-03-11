import 'dart:async';

import 'package:book/login.dart';
import 'package:book/main.dart';
import 'package:book/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
        _checkLoginStatus,
         );

  }
  
  void _checkLoginStatus(){
    User? user=FirebaseAuth.instance.currentUser;
    print(user);
    if(user!=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/book_logo.jpeg",width: 150,height: 150, fit: BoxFit.fill,),
      ),
    );
  }
}