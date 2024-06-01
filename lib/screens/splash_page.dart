import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firebase_app/screens/home_page.dart';
import 'package:todo_firebase_app/screens/on-boarding/login_page.dart';

class SplashPage extends StatefulWidget {


  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    loginlog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Todo",style: TextStyle(fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrangeAccent),),
      ),

    );
  }

  loginlog() async {
    var prefs=await SharedPreferences.getInstance();
    var check=prefs.getString(LoginPage.UID_Key);
    if(check!=null){
      if(check !=""){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));

      }else{
        Timer(Duration(seconds: 2),(){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
        });

      }

    }else{
      Timer(Duration(seconds: 2),(){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
      });

    }

  }
}
