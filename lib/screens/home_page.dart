import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firebase_app/modal/todo_modal.dart';
import 'package:todo_firebase_app/screens/on-boarding/login_page.dart';

class MyHomePage extends StatefulWidget {



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  late CollectionReference mUsers;

  String? muid;
  var titleController=TextEditingController();
  var descController=TextEditingController();


  @override
  void initState() {
    super.initState();
    getinitlog();
  }
  getinitlog() async {
    var prefs=await SharedPreferences.getInstance();
    muid=prefs.getString(LoginPage.UID_Key);
  }


  @override
  Widget build(BuildContext context) {
    mUsers=firestore.collection("user").doc(muid).collection("todos");
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo app'),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              logOutlog();
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          }, icon:Icon(Icons.logout_sharp))
        ],
      ),
      body:muid!=null ? FutureBuilder(
          future: firestore.collection("user").doc(muid).collection("todos").get(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState){
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Text("error${snapshot.error}");
            }else if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.size,
                  itemBuilder: (context,index){
                  Map<String,dynamic> allData=snapshot.data!.docs[index].data();
                    var mData=TodoModal.fromMap(allData);
                return InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context){
                      titleController.text=mData.title.toString();
                      descController.text=mData.desc.toString();
                      return bottomBar(isUpdated: true,upindex: snapshot.data!.docs[index].id,
                          createdAt:DateTime.fromMillisecondsSinceEpoch(Duration.millisecondsPerSecond).millisecond);

                    });
                  },
                  child: ListTile(
                    leading: Text("${index+1}"),
                    title: Text("${mData.title}"),
                    subtitle: Text("${mData.desc}"),
                    trailing:IconButton(onPressed: (){
                      mUsers.doc(snapshot.data!.docs[index].id).delete().then((onValue){
                        setState(() {

                        });

                      },onError: (e){
                        print("error${e}");
                      }
                      );
                    },icon: Icon(Icons.delete),),
                  ),
                );
              });
            }
            return Container();
          }) :Center(child: Text("No todos found ...")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showModalBottomSheet(context: context, builder:(context){
            titleController.clear();
            descController.clear();
            return bottomBar();
          });
        },
      ),
    );
  }
  Widget bottomBar({bool isUpdated = false, String? upindex,int? createdAt}){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(isUpdated ? "Update Todo": 'Add Todo',style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Enter Title Name',style: TextStyle(
                    fontWeight: FontWeight.w700
                ),),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller:titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                  )
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Enter Subtitle',style: TextStyle(
                    fontWeight: FontWeight.w700
                )),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller:descController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                  )
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  //var userid=widget.uid;



                  if(isUpdated!=true){
                    var  newUser=TodoModal(title:titleController.text.toString(),
                        desc:descController.text.toString());

                    mUsers.add(newUser.toMap()).then((value){
                      setState(() {

                      });
                      Navigator.pop(context);

                    },onError: (e){
                      print("Error: $e");
                    });


                  }else{
                    var  updateUser=TodoModal(
                        title:titleController.text.toString(),
                        desc: descController.text.toString());
                    mUsers.doc(upindex).update(updateUser.toMap()).then((value){

                      Navigator.pop(context);
                      setState(() {

                      });


                    },onError: (e){
                      print("Error: $e");
                    });;



                  }



                }, child:Text(isUpdated ? "Update ToDo" : 'Add ToDo')),
                ElevatedButton(onPressed: (){}, child:Text('Cancel ')),
              ],
            )
          ],
        ),
      ),
    );
  }


  logOutlog() async {
    var prefs=await SharedPreferences.getInstance();
    prefs.setString(LoginPage.UID_Key,"");
  }
}
