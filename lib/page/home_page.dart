import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../model/note.dart';
import '../model/note_data.dart';
import 'editing_note.dart';
import 'newpage.dart';
import '../data/hive_database.dart';


var hiveDatabase = HiveDatabase(); // 在 MyHomePage 顶部或初始化时初始化
 
class MyHomePage extends StatefulWidget{
  // 構造函數帶有命名參數 'key'
  const MyHomePage({super.key});
  
  get translations => null;

  @override
  State<MyHomePage>createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> translations = {};
  @override

  void initState() {
    super.initState();
   
  // 使用 Future.delayed 將初始化推遲到下一個 microtask
    Future.delayed(Duration.zero, () async{
    // 在 widget 創建時初始化筆記
     Provider.of<NotaData>(context, listen: false).initializeNotes();
     

     // 调用 _loadNotes 方法
     if (mounted) {
       await _loadNotes();
     }
  });
  }

   Future<void> _loadNotes() async {
    List<Note> notes = await hiveDatabase.loadNotes();
     if (mounted) {
      Provider.of<NotaData>(context, listen: false).setNotes(notes);
      // 初始化 translations
      Map<String, String> tempTranslations = {};
      for (var note in notes) {
        // 这里可以替换为实际的翻译逻辑
        String translation = await getTranslation(note.text);
        tempTranslations[note.text] = translation;
      }

    
    // 更新 translations
   setState(() {
     translations = {}; // 初始化翻譯映射
    });
   }
  }

  // 这是一个示例翻译逻辑，你需要替换为实际的翻译方法
  Future<String> getTranslation(String text) async {
    // 实际的翻译逻辑
    // 返回经翻译的文本
    return 'Translated: $text';
  }
// 創建新筆記的函數
  void createNewNote(){
    //新增id
    // 獲取現有筆記的數量以創建新的 id
    int id = Provider.of<NotaData>(context, listen: false).getAllNotes().length;

    //新增內文
    // 使用默認文本創建新筆記
    Note newNote = Note(
      id: id,
      text: ' ',
    );
    // 導航到筆記編輯頁面
    goToNotePage(newNote, true);
  }
    // 導航到筆記編輯頁面的函數
  void goToNotePage(Note note, bool isNewNote){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingNotePage(
          note:note,
          isNewNote: isNewNote,
        ),
      ),
    );
  }
 
  void goToNewpage(String title, Note note, bool isNewNote, {required String translationResult}) async{
    print('Navigating to NewPage with title: $title');
  
    Navigator.of(context).push(
      
      MaterialPageRoute(
       builder: (context) => NewPage(
          note: note,
          isNewNote: isNewNote,
          translationResult: translations[title] ?? '', // 使用標題查找翻譯結果
        ),
      ),
    );
    
    
  }

  // 刪除筆記的函數
  void deleteNode(Note note) {
    Provider.of<NotaData>(context, listen: false).deleteNode(note);
  }

  
  @override
  Widget build(BuildContext context) {
    return Consumer<NotaData>(
      builder: (context,value,child) =>Scaffold(
      
        backgroundColor: Color.fromARGB(255, 240, 239, 242),  //背景顏色
        //[下面需更改]
        floatingActionButton: FloatingActionButton(
          onPressed: ()=> goToNotePage(Note(id: 0, text: ''), true),
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 185, 124, 157),
          child:  const Icon(
            Icons.add, //加號:出入處
            color: Color.fromARGB(255, 234, 203, 222),
          
          ),
        ),
        
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 標題
            const Padding(
              padding:EdgeInsets.only(left:25.0, top: 75),
              child: Text('vocabuary ',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            // 筆記列表
            value.getAllNotes().length == 0
                ? const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: Text(
                        'Nothing here..',
                        style: TextStyle(color: Color.fromARGB(255, 75, 0, 0))),
                    ), //Text
                )  
                 
               :CupertinoListSection.insetGrouped(
                children: List.generate(
                  value.getAllNotes().length,
                  (index) => CupertinoListTile(
                    title: GestureDetector(
                      onTap: () =>
                        goToNewpage(
                        value.getAllNotes()[index].text ??'', 
                        value.getAllNotes()[index],
                        false,
                        translationResult: value.getAllNotes()[index].translationResult?? '',
                      ),
                      
                     child: Text(value.getAllNotes()[index].text ?? ''),
                     ),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                       onPressed: () => deleteNode(value.getAllNotes()[index]),
                    ),
                  ),
                ),
          
              ),
          ]
        )

        
                    ),
                  );
                
  }
} 