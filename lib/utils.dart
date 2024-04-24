
import 'package:async/async.dart';
import 'package:flutter/material.dart';

Future showInfoDialog(
    {required BuildContext context,
      String title = "",
      String content = "",
      String button = "OK"}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}
class ContextWrapper {
  BuildContext? context;
}
Future showLoadingDialog(
    {required BuildContext context,
      String title = "Loading",
      required Future Function() func,
      String button = "Cancel",
      void Function()? onError}) {
  ContextWrapper contextWrapper = ContextWrapper();
  var future = func().then((v) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if(contextWrapper.context!=null){
        Navigator.pop(contextWrapper.context!);
      }
    });
  }).onError((error, stackTrace){
    //await Future.delayed(const Duration(microseconds: 5000));
    if(contextWrapper.context!=null){
      Navigator.pop(contextWrapper.context!);
    }

    if (onError != null) {
      onError();
    }
  });
  var myCancelableFuture = CancelableOperation.fromFuture(
    future,
  );

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        contextWrapper.context = context;
        return AlertDialog(
          title: Text(title),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  myCancelableFuture.cancel();
                  Navigator.of(context).pop();
                },
                child: Text(button))
          ],
        );
      });
}

var day2Str=<String>["周一","周二","周三","周四","周五","周六","周日"];
String time2StringConverter(int time){
  int b=1~/2;
  var day=(time~/(24*60));
  time %=24*60;
  int hour=time~/60;
  var minute=time%60;

  return "${day2Str[day]} ${hour.toString()}:${minute.toString()}";

}
int string2TimeConverter(int week,int hour,int minute){
  bool flag=0<=week&&week<=7 && 0<=hour&&hour<60 &&0<=minute&&minute<60;
  if(!flag){
    throw Exception("invalid time");
  }
  return (week*24+hour)*60+minute;
}

({int day,int hour,int minute}) parseIntTime(int time){

  var day=(time~/(24*60)) ;
  time %=24*60;
  var hour=time~/60 ;
  var minute=time%60;
  return (
  day: day,
  hour: hour,
  minute: minute,
  );
}
