
import 'package:book/auth/login.dart';
import 'package:book/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget{
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController=TextEditingController();
  final newPassController=TextEditingController();
  final confPassController=TextEditingController();
  final firebaseAuth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.teal,
    ),
    body: SingleChildScrollView(


          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height: 50,),
              Text("Sign Up",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.teal,fontFamily: "FontMain"),),
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
                  controller:newPassController ,
                  decoration: InputDecoration(
                      label: Text("New Password"),
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
                  controller:confPassController ,
                  decoration: InputDecoration(
                      label: Text("Confirm Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      )
                  ),
                ),
              ),
              SizedBox(height: 21,),
              ElevatedButton(
                  onPressed:(){
                    registerUser();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700),
                  child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20),)
              ),
              SizedBox(height: 15,),

              TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(
                        builder: (context){
                          return Login();
                        }
                        )
                    );
                  },
                  child: Text("Already Signed up!! LOGIN"))
            ],
          ),
        ),

  );
  }

  String? validatePassword(String password){
    if(password.length<8){
      return "Password must contain at least 8 characters";
    }
    if(!RegExp(r'[A-Z]').hasMatch(password)){
      return "Password must contain at least one uppercase letter";
    }
    if(!RegExp(r'\d').hasMatch(password)){
      return "Password must contain at least one number";
    }
    return null;
  }

  void registerUser()async {
    String email = emailController.text.trim();
    String newPassword = newPassController.text.trim();
    String confPassword = confPassController.text.trim();

    if (email.isEmpty || newPassword.isEmpty || confPassword.isEmpty) {
      showMessage("All fields are required!");
      return;
    }
    if(newPassword!=confPassword){
      showMessage("Passwords do not match!");
      return;
    }
    String? passwordError=validatePassword(newPassword);
    if(passwordError!=null){
      showMessage(passwordError);
      return;
    }

    try{
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: newPassword);
      showMessage("Registration Successful!",isSuccess: true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }catch(e){
      showMessage("Error: ${e.toString()}");
    }
  }

    void showMessage(String message,{bool isSuccess=false}){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
      backgroundColor: isSuccess?Colors.green:Colors.red,));
    }
}

