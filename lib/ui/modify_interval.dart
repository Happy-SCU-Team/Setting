import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../assets.dart';
import '../http.dart';
import '../utils.dart';

class ModifyInterval extends StatefulWidget {
  const ModifyInterval({super.key});

  @override
  State<ModifyInterval> createState() => _ModifyIntervalState();
}

class _ModifyIntervalState extends State<ModifyInterval> {
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更改间隔时间"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(controller: controller,decoration: const InputDecoration(
                icon: Icon(Icons.timer),
                labelText: "新间隔时间"
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(onPressed: ()async{
                var isSuccess=false;
                String failedMsg="";

                await showLoadingDialog(context: context, func: ()async{
                  Map<String, String> headers = {
                    'Content-Type': 'application/json',
                  };
                  var a=await http.post(
                      Uri.parse("$base/update/interval"),
                      headers: headers,
                      body:jsonEncode({"account":account,"interval":int.parse(controller.text)})
                  );
                  var result=await jsonDecode(a.body);
                  isSuccess=result["is_success"];
                  failedMsg=result["failed_message"];
                });
                showInfoDialog(context: context,
                    title: isSuccess?"Successful":"Failed",
                    content: isSuccess?"":failedMsg
                );
              }, child: const Text("Update")),
            )
          ],
        ),
      ),
    );
  }
}
