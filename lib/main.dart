import 'package:flutter/material.dart';
import 'package:form_and_db/test_db_q.dart';
import './test_form_builder.dart';
import './test_db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TestDB_Q(),
    );
  }
}
