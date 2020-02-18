import 'package:flutter/material.dart';
import 'package:note_keeper/screens/notelist.dart';

main() {
  runApp(NoteKeeper());
}

class NoteKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Note Keeper App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: NoteList(),
    );
  }
}
