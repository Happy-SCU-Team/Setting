

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:setting/main.dart';
import 'package:setting/ui/all_users.dart';
import 'package:setting/ui/check_history.dart';
import 'package:setting/ui/modify_interval.dart';
import 'package:setting/ui/modify_plan.dart';
import 'package:setting/ui/modify_username.dart';

import 'assets.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void push(Widget widget){
    Navigator.of(context).push(MaterialPageRoute(builder: (builder){
      return widget;
    }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(account!), ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buttonWithPadding(onPressed: (){push(const ModifyPlan());}, text: ("更改计划信息")),
            buttonWithPadding(onPressed: (){push(const ModifyInterval());}, text: "更新提醒间隔时间"),
            buttonWithPadding(onPressed: (){push(const ModifyUsername());}, text: "更新用户名"),
            buttonWithPadding(onPressed: (){push(const CheckHistory());}, text: "查看历史"),
            buttonWithPadding(onPressed: (){push(const AllUsers());}, text: "All Users (Test)"),
            buttonWithPadding(onPressed: (){
              account=null;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                return const MyHomePage();
              }));
            }, text: ("退出登录")),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }
}
Widget buttonWithPadding({required void Function() onPressed, required String text}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(onPressed: onPressed, child: Text(text)),
  );
}
