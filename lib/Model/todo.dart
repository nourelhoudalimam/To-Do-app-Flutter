import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String uid;
  String todoText;
  bool isDone ;
  Todo({
 required this.uid,
  required this.todoText,
    this.isDone=false,

  });
   List<Todo> todof(QuerySnapshot snapshot){
    return snapshot.docs.map((e) {
    return Todo(
      isDone: e.get("isDone") ?? "", // Utilisez e.get() pour obtenir la valeur
      todoText: e.get("todoText") ?? "", // Utilisez e.get() pour obtenir la valeur
      uid: e.id,
    );
  }).toList();
  }
}
