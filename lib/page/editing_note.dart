import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../model/note.dart';
import '../model/note_data.dart';


// ignore: must_be_immutable
class EditingNotePage extends StatefulWidget{
  Note note;
  bool isNewNote;

  EditingNotePage({
    super.key,
    required this.note,
    required this.isNewNote,
  });

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }


  // 加載現有筆記
  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  // ^添加新筆記
  void addNewNote() {
    // 獲取新 ID
    int id = Provider.of<NotaData>(context, listen: false).getAllNotes().length;
    // 獲取編輯器中的文本
    String text = _controller.document.toPlainText();
    // 添加新筆記
    // String translatedText = translate(text); // 假設這是翻譯模組
    Provider.of<NotaData>(context, listen: false).addNewNote(
      Note(id: id, text: text),
    );
    
  }

  //^ 更新現有筆記
  void updateNote() {
    // 獲取編輯器中的文本
    String text = _controller.document.toPlainText();
    Provider.of<NotaData>(context, listen: false).updateNote(widget.note, text);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async{
            if (widget.isNewNote && !_controller.document.isEmpty()) {
              addNewNote();
            } else {
              updateNote();
            }
            // 等待保存完成后，再返回上一页
            await Future.delayed(Duration.zero, () {
                // 通知HomePage刷新列表
              Provider.of<NotaData>(context, listen: false).initializeNotes();
              Navigator.pop(context);// 返回到上一个页面（HomePage）
          });
        
          },
          color: Colors.black,
        ),
      ),
    
    body:QuillProvider(
      configurations: QuillConfigurations(
      controller: _controller,
      sharedConfigurations: const QuillSharedConfigurations(
       locale: Locale('zh'),
      ),
     ),
      child: Column(
        children: [
          const QuillToolbar(),
          Expanded(
            child: QuillEditor.basic(
               configurations: const QuillEditorConfigurations(
                   readOnly: false, // true for view only mode
               ),
            ),
          ),
          
        ],

        
      ),
    ),
  );
}
      
    
        

}