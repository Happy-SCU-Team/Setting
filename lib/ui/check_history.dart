import 'package:flutter/material.dart';

class CheckHistory extends StatefulWidget {
  const CheckHistory({super.key});

  @override
  State<CheckHistory> createState() => _CheckHistoryState();
}

class _CheckHistoryState extends State<CheckHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History"),),
      body: Placeholder(),
    );
  }
}
