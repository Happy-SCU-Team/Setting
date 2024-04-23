import 'package:flutter/material.dart';
import 'package:setting/http.dart';
import 'package:setting/setting.dart';
import 'package:setting/ui/all_users.dart';
import 'package:setting/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assets.dart';

void main() {
  var prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    preferences=value;
    account=value.getString(ACCOUNT);
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '音量计遥控器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home:account==null? const MyHomePage():Setting(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isSuccess=false;
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('音量计遥控器'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("   Login",textScaler: TextScaler.linear(1.5),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle),
                    labelText: "Account"
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:ElevatedButton(onPressed: ()async{
                  await showLoadingDialog(context: context, func: ()async{
                    var a=await httpGetJson("/check/account/${controller.text}");
                    if(a["is_exist"]==true){
                      isSuccess=true;
                    }else{
                      throw Exception("login failed");
                    }
                  },onError: (){
                    showInfoDialog(
                        context: context,
                        title: "Error",
                        content:
                        "can not login");
                  });
                  if(isSuccess){
                    account=controller.text;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                      return Setting();
                    }));
                  }
                }, child: const Text("Login"),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const AllUsers();
                      }));
                }, child: const Text("Get All Users (BETA)"),),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
