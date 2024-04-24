import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:setting/assets.dart';
import 'package:setting/utils.dart';
import 'package:http/http.dart' as http;

import '../http.dart';

class ModifyPlan extends StatefulWidget {
  const ModifyPlan({super.key});

  @override
  State<ModifyPlan> createState() => _ModifyPlanState();
}

class _ModifyPlanState extends State<ModifyPlan> {
  List<TimeSegment>? list;
  @override
  Widget build(BuildContext context) {
    var c=<Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: (){fetch();}, child: const Text("Fetch")),
          ElevatedButton(onPressed: (){
            update();
          }, child: const Text("Update")),
          ElevatedButton(onPressed: (){
            setState(() {
              list!.add(TimeSegment());

            });
          }, child: const Text("+")),
          ElevatedButton(onPressed: (){
            setState(() {
              list!.removeLast();
            });
          }, child: const Text("-")),
      ],),
      const Text("Time Segments")
    ];
    if(list==null){
      c.add(const CircularProgressIndicator());
      c.add(const Text("Loading"));
    }else{
      for(var i in list!){
        c.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: TimeSegmentModifier(timeSegment: i),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("更改计划信息"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: c,
      ),
    );
  }
  @override
  void initState() {
    fetch();
    super.initState();
  }
  Future update()async{
    var segments=[];
    for(var i in list!){
      segments.add({"start_time":i.start,"end_time":i.end});
    }
    var info={"account":account,"segments":segments};

    var isSuccess=false;
    String failedMsg="";

    await showLoadingDialog(context: context, func: ()async{
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      var a=await http.post(
          Uri.parse("$base/update/schedule"),
          headers: headers,
          body:jsonEncode(info)
      );
      var result=await jsonDecode(a.body);
      isSuccess=result["is_success"];
      failedMsg=result["failed_message"];
    });
    showInfoDialog(context: context,
        title: isSuccess?"Successful":"Failed",
        content: isSuccess?"":failedMsg
    );
  }

  Future fetch()async{
    setState(() {
      list=null;
    });
    var a=await httpGetJson("/$account/schedule");
    setState(() {
      list=[];
      for(var i in a){
        var segment=TimeSegment()..start=i["start_time"]..end=i["end_time"];
        list!.add(segment);
      }
    });
  }
}

class TimeSegment{
  int start=-1;
  int end=-1;
}

class TimeSegmentModifier extends StatefulWidget {
  final TimeSegment timeSegment;
  const TimeSegmentModifier({super.key,required this.timeSegment});

  @override
  State<TimeSegmentModifier> createState() => _TimeSegmentModifierState();
}

class _TimeSegmentModifierState extends State<TimeSegmentModifier> {
  late TimeSegment timeSegment;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimePicker(setTime: (setTime){timeSegment.start=setTime;}, time0: timeSegment.start),
        const Text("To"),
        TimePicker(setTime: (setTime){ timeSegment.end=setTime;}, time0: timeSegment.end),
      ],
    );
  }
  @override
  void initState() {
    timeSegment=widget.timeSegment;
    super.initState();
  }
}


class TimePicker extends StatefulWidget {
  final void Function(int time) setTime;
  final int time0;
  const TimePicker({super.key, required this.setTime, required this.time0});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late int time;
  @override
  void initState() {
    time=widget.time0;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){
      _showInputDialogContent(context);
    }, child: Text(time2StringConverter(time)));
  }
  void _showInputDialogContent(BuildContext context) {
    var result=parseIntTime(time);
    final TextEditingController weekday = TextEditingController(text: result.day.toString());
    final TextEditingController hour = TextEditingController(text: result.hour.toString());
    final TextEditingController minute = TextEditingController(text: result.minute.toString());

    // 显示输入对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('请输入'),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: weekday,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.account_tree_outlined),
                      labelText: "weekday"
                  ),
                ),
                TextField(
                  controller: hour,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer),
                      labelText: "hour"
                  ),
                ),
                TextField(
                  controller: minute,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer),
                      labelText: "minute"
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                // 获取输入的内容并执行相关操作
                setState(() {
                  int _day,_hour,_minute;
                  _day=int.parse(weekday.text);
                  _hour=int.parse(hour.text);
                  _minute=int.parse(minute.text);

                  try{
                    time=string2TimeConverter(
                        _day,
                        _hour,
                        _minute
                    );
                    widget.setTime(time);
                  }catch(e){
                    showInfoDialog(context: context,title: "Invalid Time");
                  }
                });
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }
}




