class Note {
  int id;
  String text;
  String translationResult; // 新增的 translationResult 屬性

  Note( {
    required this.id, 
    required this.text,
    this.translationResult = '',
   });
} 