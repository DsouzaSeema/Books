import 'package:book/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogOut extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_LogOut();

}

class _LogOut extends State<LogOut>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          SystemNavigator.pop();
        },),
      ),
      body:
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logged Out :(",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontFamily: "FontMain"),
                    ),
                    SizedBox(height: 21,),
                    ElevatedButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                    }
                    , child: Text("Login",style: TextStyle(color: Colors.black54),))
                  ],
                ),
              ),
            ),



    );
  }

}