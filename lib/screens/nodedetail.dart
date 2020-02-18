import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NodeDetail extends StatefulWidget {
  final Note nn;
  var appbartitle;

  @override
  NodeDetail(this.nn, this.appbartitle);

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Nodestate(nn, appbartitle);
  }
}

class Nodestate extends State<NodeDetail> {
  final Note nn;

  @override
  Nodestate(this.nn, this.appbartitle);

  var tkey = GlobalKey<FormState>();
  var dkey = GlobalKey<FormState>();

//  Textf
  DatabaseHelper helper = DatabaseHelper();
  var appbartitle;
  var _priority = ['High', 'Low'];
  var _currvalue = 'Low';
  TextEditingController tcontroller = TextEditingController();
  TextEditingController dcontroller = TextEditingController();

  Widget build(BuildContext context) {
    // TODO: implement build
    var key = GlobalKey<FormState>();
    tcontroller.text = nn.title;
    dcontroller.text = nn.description;
    return WillPopScope(
        onWillPop: () {
          movetoLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appbartitle),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  movetoLastScreen();
                },
              ),
            ),
            body: Form(
                key: key,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
//                leading: Icon(Icons.label_important),
                        title: DropdownButton(
                          elevation: 10,
                          items: _priority.map((String dropdownitem) {
                            return DropdownMenuItem<String>(
                              value: dropdownitem,
                              child: Text(dropdownitem),
                            );
                          }).toList(),
                          value: updatePriorityString(nn.priority),
                          onChanged: (String newValue) {
                            setState(() {
                              updatePriorityInt(newValue);
                            });
                          },
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: tcontroller,
                            onChanged: (value) {
                              updateTitle();
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter title';
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'Title',
                                hintText: 'Enter title of your note',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: dcontroller,
                            onChanged: (value) {
                              updateDesc();
                            },
                            decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: 'Enter details of your note',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                    color: Colors.cyan,
                                    elevation: 10.0,
                                    child: Text(
                                      'Save',
                                      textScaleFactor: 1.5,
                                    ),
                                    onPressed: () {
                                      if (key.currentState.validate()) _save();
                                    }),
                              ),
                              Container(width: 10.0),
                              Expanded(
                                child: MaterialButton(
                                    color: Colors.cyan,
                                    elevation: 10.0,
                                    child: Text(
                                      'Delete',
                                      textScaleFactor: 1.5,
                                    ),
                                    onPressed: () {
                                      _delete();
                                    }),
                              )
                            ],
                          ))
                    ],
                  ),
                ))));
  }

  void updatePriorityInt(String value) {
    switch (value) {
      case 'High':
        nn.priority = 1;
        break;
      case 'Low':
        nn.priority = 2;
        break;
    }
  }

  String updatePriorityString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priority[0];
        break;
      case 2:
        priority = _priority[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    nn.title = tcontroller.text;
  }

  void updateDesc() {
    nn.description = dcontroller.text;
  }

  void _save() async {
    movetoLastScreen();
    nn.date = DateFormat.yMMMd().format(DateTime.now());
    int result = 0;
    if (nn.id != null) {
      result = await helper.updateNote(nn);
    } else {
      result = await helper.insertNote(nn);
    }

    if (result != 0) {
      _showalertdialogue('Status', 'Note Saved Successfully');
    } else {
      _showalertdialogue('Status', 'Problem Saving Node');
    }
  }

  _showalertdialogue(String status, String desc) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(status),
      content: Text(desc),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void movetoLastScreen() {
    Navigator.pop(context, true);
  }

  void _delete() async {
    int result;
    movetoLastScreen();
    if (nn.id == null) {
      result = 0;
    } else {
      result = await helper.deleteNote(nn.id);
    }

    if (result != 0)
      _showalertdialogue('Status', 'Note was Deleted');
    else
      _showalertdialogue('Status', 'The Note was empty');
  }
}
