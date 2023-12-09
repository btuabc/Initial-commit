import 'package:flutter/material.dart';


import '../data/hive_database.dart';
import '../model/note.dart';

var hiveDatabase = HiveDatabase();

class NewPage extends StatefulWidget {
  final bool isNewNote;
  final Note note;
  final String translationResult;
  final String translatedText;

  NewPage({
    required this.isNewNote,
    required this.note,
    required this.translationResult,
    this.translatedText = '',
    Key? key,
  }) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

// NewPage 的狀態類
class _NewPageState extends State<NewPage> {
  final TextEditingController _noteController = TextEditingController();



  @override
  void initState() {
    super.initState();
    // 如果存在，加載現有的筆記
    _loadExistingNote();
    // 將筆記控制器的文本設置為翻譯結果
    _noteController.text = widget.translationResult;
  }

  // 加載現有筆記的函數
  void _loadExistingNote() {
    _noteController.text = widget.translationResult;
  }

  String translationResult = '';
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... 其他 AppBar 的設定 ..
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Translation Result', // 添加标题
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.translationResult,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _noteController,
                    readOnly: true, // 要改 true，視唯讀
                    maxLines: null,
                    
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}