import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/hive_database.dart';

import 'note.dart';

class NotaData extends ChangeNotifier{

  // Hive 資料庫實例
  final db =HiveDatabase();

  // 筆記的整體列表
  List<Note> allNotes =[
  ];

    // 初始化筆記列表 
  Future<void> initializeNotes() async {
    // 從 Hive 資料庫加載筆記
    allNotes = await db.loadNotes();
    notifyListeners();
  }


  // 獲取所有筆記
  List<Note>getAllNotes(){
    return allNotes;
  }

  // 獲取所有筆記
  void addNewNote(Note note) {
    allNotes.add(note);
    notifyListeners();
    // 將新筆記保存到 Hive 資料庫
    db.savedNotes(allNotes);
  }
  


  // 新增一條新筆記
  void  updateNote(Note note, String text) {
    // 通知依賴此數據的 Widget 進行更新
    for(int i=0; i< allNotes.length; i++){
      // 找到相應的筆記
      
      if(allNotes[i].id == note.id){
        allNotes[i].text =text;
        // 更新完筆記後，通知依賴此數據的 Widget 進行更新
        
         break;
      }
    }
    notifyListeners();
  }

  // 刪除筆記
  void deleteNode(Note note) async{
    allNotes.remove(note);
     // 通知依賴此數據的 Widget 進行更新
    notifyListeners();

    
  }
  // 添加这个方法来设置笔记
  void setNotes(List<Note> notes) {
    allNotes = notes;
    notifyListeners(); // 通知监听器数据已更新
  }

}



