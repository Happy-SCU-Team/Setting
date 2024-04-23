import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:setting/assets.dart';
import 'package:setting/utils.dart';
import 'package:http/http.dart' as http;
import '../http.dart';

class ModifyUsername extends StatefulWidget {
  const ModifyUsername({super.key});

  @override
  State<ModifyUsername> createState() => _ModifyUsernameState();
}

class _ModifyUsernameState extends State<ModifyUsername> {
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更改用户名"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(controller: controller,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: "新用户名"
            ),),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(onPressed: ()async{
                var isSuccess=false;
                String failedMsg="";

                await showLoadingDialog(context: context, func: ()async{
                  Map<String, String> headers = {
                    'Content-Type': 'application/json',
                  };
                  var a=await http.post(
                      Uri.parse("$base/update/account"),
                      headers: headers,
                      body:jsonEncode({"account":account,"new_account":controller.text})
                  );
                  var result=await jsonDecode(a.body);
                  isSuccess=result["is_success"];
                  failedMsg=result["failed_message"];

                });
                showInfoDialog(context: context,
                    title: isSuccess?"Successful":"Failed",
                    content: isSuccess?"":failedMsg
                );
                if(isSuccess){
                  account=controller.text;
                }
              }, child: Text("Update")),
            )
          ],
        ),
      ),
    );
  }
}
