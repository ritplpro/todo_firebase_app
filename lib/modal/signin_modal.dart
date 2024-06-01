class SigninModal{
  String name;
  SigninModal({required this.name});


  factory SigninModal.fromMap(Map<String,dynamic>map){
    return SigninModal(
        name: map["name"]);
  }



  Map<String,dynamic> toMap(){
    return{
      "name":name
    };
  }
}