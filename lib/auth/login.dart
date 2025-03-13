import 'package:book/main.dart';
import 'package:book/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController=TextEditingController();
  var passController=TextEditingController();
  final firebaseAuth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),onPressed: (){
          SystemNavigator.pop();
        },),
      ),
      body:

           SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Text("Login",style: TextStyle(fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    fontFamily: "FontMain"),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller:emailController ,
                    decoration: InputDecoration(
                        label: Text("Email"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 11,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller:passController ,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 11,),

                TextButton(
                    onPressed: (){
                      forgotPassword();
                    },
                    child:Padding(
                      padding: const EdgeInsets.only(right: 200.0),
                      child: Text("Forgot password",style: TextStyle(color: Colors.red)),
                    ),
                ),
                SizedBox(height: 21,),
                ElevatedButton(
                    onPressed:(){
                      loginUser();
                    },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade500),
                    child: Text("Login",style: TextStyle(fontSize: 20,color: Colors.white),),
                ),
                SizedBox(height: 15,),
            
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context){
                            return SignUp();
                          }
                      )
                      );
                    },
                    child: Text("I haven't Signed up!! SIGNUP"))
              ],
            ),
          ),


    );
  }

  void loginUser()async{
    String email=emailController.text.trim();
    String password=passController.text.trim();
    if(email.isEmpty || password.isEmpty){
      showMessage("PLease enter both the email and password!");
      return;
    }
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      showMessage("Login Successful!",isSuccess: true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    }catch(e){
      showMessage("Error: ${e.toString()}");
    }
  }

  void forgotPassword() async{
    String email=emailController.text.trim();
    if(email.isEmpty){
      showMessage("Please enter your email to reset the password");
      return;
    }
    try{
      await firebaseAuth.sendPasswordResetEmail(email: email);
      showMessage("Password reset link sent to your email",isSuccess: true);
    }catch(e){
      showMessage("Error: ${e.toString()}");
    }
}

  void showMessage(String message,{bool isSuccess=false}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
    backgroundColor: isSuccess?Colors.green:Colors.red,));
  }
}