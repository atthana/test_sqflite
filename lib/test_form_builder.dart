import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  // 'email': '',
                  // 'password': '',
                  // 'kbank': '',
                },
                autovalidateMode: AutovalidateMode.disabled, // สามารถเลือกได้ว่าจะให้ validate ตลอดเวลา หรือ disable  ไปเลย
                child: Column(
                  children: <Widget>[
                    // FormBuilderTextField(
                    //   maxLines: 1,
                    //   attribute: "email",
                    //   decoration: InputDecoration(
                    //     contentPadding:EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    //     labelText: "Email",
                    //     // fillColor: Colors.amber, // ถ้าจะลงสีใน TextField ต้องใช้ fillColor + filled
                    //     // filled: true,
                    //     border: OutlineInputBorder(),
                    //     isDense:false, // เป็นการกำหนดความสูงของ TextField นะคับว่าจะให้หนาแน่นแค่ไหน default = false,
                    //   ),
                    //   validators: [
                    //     FormBuilderValidators.required(errorText: "ป้อนข้อมูลอีเมมลล์"),
                    //     FormBuilderValidators.email(errorText: "รูปแบบอีเมลล์ไม่ถูกต้อง"),
                    //   ],
                    // ),
                    // SizedBox(height: 10,),
                    // FormBuilderTextField(
                    //   obscureText: true,
                    //   inputFormatters: [LengthLimitingTextInputFormatter(6)],
                    //   maxLines: 1,
                    //   attribute: "password",
                    //   decoration: InputDecoration(
                    //     contentPadding:EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    //     labelText: "Password",
                    //     // fillColor: Colors.amber, // ถ้าจะลงสีใน TextField ต้องใช้ fillColor + filled
                    //     // filled: true,
                    //     border: OutlineInputBorder(),
                    //     isDense:false, // เป็นการกำหนดความสูงของ TextField นะคับว่าจะให้หนาแน่นแค่ไหน default = false,
                    //   ),
                    //   validators: [
                    //     FormBuilderValidators.required(errorText: "ป้อน password ของคุณ"),
                    //     FormBuilderValidators.maxLength(6),
                    //   ],
                    // ),
                    // FormBuilderCheckbox(
                      
                    //   attribute: 'creditcard',
                    //   label: Text(
                    //       "Pay with credit card"),
                    //   validators: [
                    //     FormBuilderValidators.requiredTrue(
                    //       errorText:
                    //           "You must select which payment you need",
                    //     ),],
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     isCollapsed: true
                    //     ),
                    // ),
                    // FormBuilderCheckbox(
                    //   attribute: 'kplus',
                    //   label: Text(
                    //       "Pay with KPLUS"),
                    //   validators: [
                    //     FormBuilderValidators.requiredTrue(
                    //       errorText:
                    //           "You must select which payment you need",
                    //     ),],),

                    FormBuilderCheckboxGroup(
                      decoration:
                      InputDecoration(labelText: "The language of my people"),
                      attribute: "languages",
                      initialValue: ["Dart"],
                      options: [
                        FormBuilderFieldOption(value: "Dart"),
                        FormBuilderFieldOption(value: "Kotlin"),
                        FormBuilderFieldOption(value: "Java"),
                        FormBuilderFieldOption(value: "Swift"),
                        FormBuilderFieldOption(value: "Objective-C"),
                      ],
                    ),


                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                        } 
                      }),
                  MaterialButton(
                    color: Colors.amber,
                    child: Text("Reset"),
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
