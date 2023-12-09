import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/model/note.dart';


class HiveDatabase{
// reference our hive box
  late Box<List<dynamic>> _myBox;

  // 构造函数中打开 Hive Box
  HiveDatabase() {
    _openBox();
  }

  // 打开 Hive Box
  Future<void> _openBox() async {
    _myBox = await Hive.openBox<List<dynamic>>('note_database');
  }


//load notes
//load notes
  Future<List<Note>> loadNotes() async {
    await _openBox(); // 等待 _myBox 初始化完成
    List<Note> savedNotesFormatted = [];

  // if there exist notes, return that, otherwise return empty list
  if (_myBox.get("ALL_NOTES") != null){
    List<dynamic> savedNotes = _myBox.get("ALL_NOTES")!;
    for (int i=0; i < savedNotes. length; i++){
      // create individual note
      Note individualNote =
          Note(id: savedNotes[i][0], 
          text: savedNotes[i][1],
          
          );
        // add to list
        savedNotesFormatted.add(individualNote);
    }
  } else{
    // default first note 
    savedNotesFormatted.add(
      Note(id: 0, text: 'First Note'),
    );
  }

  return savedNotesFormatted;
}

//save notes
void savedNotes(List<Note> allNotes){
  List<List<dynamic>> allNotesFormatted =[
    /*

    [
      [ 0, "First Note"],
      [ 1, "Second Note"],
      ..

    ]
    */
  ];
    

    //each note has an id and text
     for (var note in allNotes) {
      int id= note.id;
      String text = note.text;
    
      allNotesFormatted.add([id, text]);
    }

    // then store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
}






}
