import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Tutorial',
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: Text(
            'Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 30.0
            ),
          ),
        ),
      ),

    );
  }
}
