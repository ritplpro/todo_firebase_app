import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firebase_app/screens/home_page.dart';
import 'package:todo_firebase_app/screens/on-boarding/signin_page.dart';

class LoginPage extends StatelessWidget {
  static const String UID_Key="uid";
  FirebaseAuth  firebaseAuth=FirebaseAuth.instance;
  var emailController=TextEditingController();
  var passController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              children: [
                Text("Email Address"),
              ],
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21)
                  )
              ),
            ),
            SizedBox(height: 21,),
            Row(
              children: [
                Text("Password"),
              ],
            ),
            TextField(
              controller: passController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21)
                  )
              ),
            ),
            SizedBox(height: 21,),
            ElevatedButton(onPressed: () async {

              try{
                await firebaseAuth.signInWithEmailAndPassword(
                    email: emailController.text.toString(), password: passController.text.toString()).then((onValue) async {


                  var prefs=await SharedPreferences.getInstance();
                  prefs.setString(UID_Key, onValue.user!.uid);

                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MyHomePage()));

                });


              }on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }



            }, child: Text("Login")),
            SizedBox(height: 21,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don`t have account"),
                TextButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>SigninPage()));
                }, child: Text("Create account ?",
                  style: TextStyle(fontWeight: FontWeight.w600),))
              ],
            )

          ],
        ),
      ),
    );
  }
}
