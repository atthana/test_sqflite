import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_and_db/utils/database_q.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqflite/sqflite.dart';

// Fix of autovalidate https://github.com/flutter/flutter/commit/7fdd9218b0b9af2c1115c633fa79319eeb83949dC

class TestDB extends StatefulWidget {
  TestDB({
    Key key, 
  }) : super(key: key);

  @override
  _TestDBState createState() => _TestDBState();
}

class _TestDBState extends State<TestDB> {
  // Explicit
  List<Map> customers = [];
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool _autovalidate = false;
  DBHelper dbHelper;
  Database db; // เราต้องมี type Database มารับนะ

  // Method
  _getCustomer() async {
    db = await dbHelper.db;
    var cust = await db.rawQuery(
        'SELECT * FROM customers ORDER By id DESC'); // query ค่ามาเก็บไว้ใน list customers.
    setState(() {
      // rebuilt เพื่อให้มันไปแสดงใน ListView นะ
      customers = cust;
    });
  }

  _insertCustomer(Map values) async {
    db = await dbHelper.db;
    await db.rawInsert('INSERT INTO customers (name) VALUES (?)',
        [values['name']]); // อันนี้ insert แค่ field เดียวก้อจะง่ายหน่อย
    _getCustomer();
  }

  _updateCustomer(int id, Map values) async {
    db = await dbHelper.db;
    await db.rawInsert('UPDATE customers SET name=? WHERE id=?',
        [values['name'], id]); // อันนี้ insert แค่ field เดียวก้อจะง่ายหน่อย
    // ถ้ามีหลาย column ก๊ comma ไปได้เรื่อยๆนะ ตรง name=?, surname=? ประมาณนี้
    _getCustomer();
  }

  _deleteCustomer(int id) async {
    db = await dbHelper.db;
    await db.rawInsert('DELETE FROM customers WHERE id=?',[id]); // อันนี้ insert แค่ field เดียวก้อจะง่ายหน่อย
    // ถ้ามีหลาย column ก๊ comma ไปได้เรื่อยๆนะ ตรง name=?, surname=? ประมาณนี้
    _getCustomer(); // ทุกครั้งที่ update กับลบออก เราก้อจะ _getCustomer() อีกรอบให้มัน rebuilt หน้าจอนะ
  }

  @override
  void initState() {
    super.initState();
    dbHelper =
        DBHelper(); // พอเข้ามาหน้านี้ ก้อ new instance ของ dbHelper ขึ้นมาเลย
    _getCustomer();
  }

  _insertForm() {
    Alert(
        context: context,
        title: "เพิ่มชื่อลูกค้า",
        closeFunction: () {},
        content: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                // 'dob': DateTime.now(),
                'name': '',
              },
              // autovalidate: _autovalidate,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "name",
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "ชื่อ - นามสกุล",
                      labelStyle: TextStyle(color: Colors.black87),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: 'ป้อนข้อมูลชื่อ-สกุลด้วย'),
                    ],
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
                print(_fbKey.currentState.value);
                _insertCustomer(_fbKey
                    .currentState.value); // เป็นการส่ง name เข้ามานั่นแหละ
                Navigator.pop(context);
              } else {
                setState(() {
                  _autovalidate = true;
                });
              }
            },
            child: Text(
              "เพิ่มข้อมูล",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _updateForm(int id, String name) {
    Alert(
        context: context,
        title: "แก้ไขข้อมูลลูกค้า",
        closeFunction: () {},
        content: Column(
          children: <Widget>[
            FormBuilder(
              key: _fbKey,
              initialValue: {
                // 'dob': DateTime.now(),
                'name': '$name',
              },
              // autovalidate: _autovalidate,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "name",
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "ชื่อ - นามสกุล",
                      labelStyle: TextStyle(color: Colors.black87),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: 'ป้อนข้อมูลชื่อ-สกุลด้วย'),
                    ],
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
                print(_fbKey.currentState.value);
                _updateCustomer(
                    id,
                    _fbKey
                        .currentState.value); // เป็นการส่ง name เข้ามานั่นแหละ
                Navigator.pop(context);
              } else {
                setState(() {
                  _autovalidate = true;
                });
              }
            },
            child: Text(
              "แก้ไขข้อมูล",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST SQLITE'),
        actions: <Widget>[
          IconButton(
              icon: Icon((Icons.person_add)),
              onPressed: () {
                print('Pressed add person');
                _insertForm();
              })
        ],
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(customers[index]['id'].toString()),
                // key อันนี้คือ unique key นะ เป็นข้อกำหนดที่ต้องนำมาใส่ ซึ่งคีย์ที่มันไม่ซ้ำกันแน่��ก้อ primary key เราไง แต่รับเป็น String จึงต้อง .toString ด้วย
                background: Container(
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      Text('แก้ไข',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ), // สำหรับปัดด้านซ้าย
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text('ลบ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ), // สำหรับปัดด้านขวา,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "ยืนยันการลบข้อมูล",
                      desc:
                          "แน่ใจว่าต้องการลบข้อมูลคุณ ${customers[index]['name']} หรือไม่",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "ใช่ ต้องการลบ",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteCustomer(customers[index]['id']);
                          },
                          color: Colors.red,
                        ),
                        DialogButton(
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          // gradient: LinearGradient(
                          //   colors: [
                          //   Color.fromRGBO(116, 116, 191, 1.0),
                          //   Color.fromRGBO(52, 138, 199, 1.0)
                          // ]),
                        )
                      ],
                    ).show();
                  } else {
                    _updateForm(
                        customers[index]['id'], customers[index]['name']);
                  }
                  return false;
                },

                //========================================================
                child: ListTile(
                  title: Text('${customers[index]['name']}'),
                  subtitle: Text('${customers[index]['id']}'),
                  trailing: Chip(
                    label: Text('XXX'),
                    backgroundColor: Colors.greenAccent,
                  ),
                ));
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
                thickness: 2.0,
              ),
          itemCount: customers.length),
    );
  }
}
