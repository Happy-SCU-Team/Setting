import 'package:flutter/material.dart';

import '../http.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  var users=[];
  @override
  Widget build(BuildContext context) {

    var c=<Widget>[];
    for(var i in users){
      c.add(Text(i));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("All Users"),),
      body:users.isEmpty?const Text("loading"): Column(
        children: c,
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    fetch();
  }
  Future fetch()async{
    var a=await httpGetJson("/all_account");
    setState(() {
      users=a;
    });
  }
}
