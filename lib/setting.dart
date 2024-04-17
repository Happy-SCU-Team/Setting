import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Setting extends StatefulWidget {
  final String account;
  Setting({super.key,required this.account});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late String account;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(account),),);
  }
  @override
  void initState() {
    account=widget.account;
    super.initState();
  }
}
