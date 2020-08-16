class MemoModel {
  final int id;
  final String title;
  final String content;

  MemoModel({this.id, this.title, this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"id": id, "title": title, "content": content};
  }

//  String toString() {
//    return "#$id - Title: $title - Content $content";
//  }
}
