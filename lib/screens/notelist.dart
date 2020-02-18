import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'nodedetail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Liststate();
  }
}

class Liststate extends State<NoteList> {
  int count = 0;
  List<Note> note;
  DatabaseHelper _databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Note list'),
      ),
      body: getNodeListView(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          gotonote(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
      ),
    );
  }

  ListView getNodeListView(BuildContext context) {
//    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    if (note == null) {
      note = List<Note>();
      updateListView();
    }
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getIconColor(note[position].priority),
              child: getIcon(note[position].priority),
            ),
            title: Text(note[position].title),
            subtitle: Text(note[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _delete(context, note[position]);
              },
            ),
            onTap: () {
              gotonote(note[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Color getIconColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.cyan;
    }
  }

  Icon getIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void gotonote(Note nn, String str) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NodeDetail(nn, str);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await _databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _snackbar(context, 'Node Deleted Successfully');
      updateListView();
    }
  }

  _snackbar(BuildContext context, String title) {
    final snackbar = SnackBar(content: Text(title));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.intializeDatabse();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = _databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.note = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
