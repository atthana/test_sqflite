import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:form_and_db/utils/database_q.dart';

class TestDB_Q extends StatefulWidget {
  @override
  _TestDB_QState createState() => _TestDB_QState();
}

class _TestDB_QState extends State<TestDB_Q> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<Map> customers = [];
  DBHelper dbHelper;
  Database db;

  _getCustomer() async {
    db = await dbHelper.db; // เป็นการ get db ออกมา
    var cust = await db.rawQuery("SELECT * FROM users ORDER BY id DESC");
    setState(() {
      customers = cust;
    });
  }

  _insertCustomer(Map values) async {
    db = await dbHelper.db;
    await db.rawInsert("INSERT INTO users (name) VALUES (?)", [values['name']]);
    _getCustomer();
  }

  _updateCustomer(int id, Map values) async {
    db = await dbHelper.db;
    await db.rawUpdate(
        "UPDATE users SET name = ? WHERE id = ?", [values['name'], id]);
    _getCustomer(); // _getCustomer() to rebuild screen
  }

  _deleteCustomer(int id) async {
    db = await dbHelper.db;
    await db.rawDelete("DELETE FROM users WHERE id = ?", [id]);
    _getCustomer();
  }

  @override
  void initState() {
    dbHelper = DBHelper(); // new instance ขั้นมา
    _getCustomer();
    super.initState();
  }

  _insertForm() {
    Alert(
        context: context,
        title: "ADD USER INFO",
        // closeFunction: () => Navigator.pop(context),
        content: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                'name': '',
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "name",
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      labelText: "Name - Surname",
                      border: OutlineInputBorder(),
                    ),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Fill your name first"),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (_fbKey.currentState.saveAndValidate()) {
                // print(_fbKey.currentState.value);
                // ถ้ามีการกดปุ่ม ก้อจะนำข้อมูลตรงนี้ไป save ลง sqlite ต่อไปนะ
                _insertCustomer(_fbKey.currentState.value);
                Navigator.pop(context);
              }
            },
            child: Text(
              "Add users",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _updateForm(int id, String name) {
    Alert(
        context: context,
        title: "EDIT USER INFO",
        // closeFunction: () => Navigator.pop(context),
        content: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {'name': '$name',},
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    maxLines: 1,
                    attribute: "name",
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      labelText: "Name - Surname",
                      border: OutlineInputBorder(),
                    ),
                    validators: [
                      FormBuilderValidators.required(errorText: "Fill your name first"),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],),),],),
        buttons: [
          DialogButton(
            onPressed: () {
              if (_fbKey.currentState.saveAndValidate()) {
                _updateCustomer(id, _fbKey.currentState.value);
                Navigator.pop(context);
              }
            },
            child: Text("Edit users",style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLITE of USERS"),
        actions: [
          IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                _insertForm();
              })
        ],
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(customers[index]['id'].toString()),
              background: Container(
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.edit, color: Colors.white),
                    Text("Edit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Text("Delete",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Confirm to Delete",
                    desc:
                        "Are you sure want to delete '${customers[index]['name']}' ?",
                    buttons: [
                      DialogButton(
                          child: Text(
                            "Yes, want to delete",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteCustomer(customers[index]['id']);
                          },
                          color: Colors.red),
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        // gradient: LinearGradient(
                        //   colors: [
                        //   Color.fromRGBO(116, 116, 191, 1.0),
                        //   Color.fromRGBO(52, 138, 199, 1.0)
                        // ],
                        // ),
                      )
                    ],
                  ).show();
                } else {
                  _updateForm(customers[index]['id'], customers[index]['name']);
                }
                return false;
              },
              child: ListTile(
                title: Text('${customers[index]['name']}'),
                subtitle: Text('${customers[index]['id']}'),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(), // ตัวแยกแต่ละ่ item
          itemCount: customers.length),
    );
  }
}
