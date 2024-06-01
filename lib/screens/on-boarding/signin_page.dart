import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/modal/signin_modal.dart';

class SigninPage extends StatelessWidget {
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  var namecontroller=TextEditingController();
  var emailcontroller=TextEditingController();
  var passcontroller=TextEditingController();

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
                Text("Enter your Name"),
              ],
            ),
            TextField(
              controller: namecontroller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21)
                )
              ),
            ),
            SizedBox(height: 21,),
            Row(
              children: [
                Text("Email Address"),
              ],
            ),
            TextField(
              controller: emailcontroller,
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
              controller: passcontroller,
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
                var cred=await firebaseAuth.createUserWithEmailAndPassword(
                    email: emailcontroller.text.toString(),
                    password: passcontroller.text.toString());
                      var newuser=SigninModal(name: namecontroller.text.toString());
                      firestore.collection("user").doc(cred.user!.uid).set(newuser.toMap());
                      Navigator.pop(context);

              }on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }




            }, child: Text("Create Account"))

          ],
        ),
      ),
    );
  }
}
