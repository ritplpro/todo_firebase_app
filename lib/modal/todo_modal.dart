class TodoModal{
  String title;
  String desc;
  TodoModal({required this.title,required this.desc});


  factory TodoModal.fromMap(Map<String,dynamic> map){
    return TodoModal(
        title: map["title"],
        desc: map["desc"]);
  }

  Map<String,dynamic> toMap(){
    return {
      "title":title,
      "desc":desc
    };
  }

}