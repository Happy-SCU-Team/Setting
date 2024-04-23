import 'package:flutter/material.dart';

class ModifyPlan extends StatefulWidget {
  const ModifyPlan({super.key});

  @override
  State<ModifyPlan> createState() => _ModifyPlanState();
}

class _ModifyPlanState extends State<ModifyPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更改计划信息"),),
    );
  }
}
