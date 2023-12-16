import 'package:flutter/material.dart';
import 'package:my_app/Model/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService extends StatefulWidget {
   CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todos');

List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
  return snapshot.docs.map((e) {
    return Todo(
      isDone: e.get("isDone") ?? "", // Utilisez e.get() pour obtenir la valeur
      todoText: e.get("todoText") ?? "", // Utilisez e.get() pour obtenir la valeur
      uid: e.id,
    );
  }).toList();
}



Stream<List<Todo>> todoList() {
  return todoCollection.snapshots().map(todoFromFirestore);
  }
   Future updateTodoIsDone(uid) async {
   

     DocumentSnapshot todoSnapshot = await todoCollection.doc(uid).get();

  
    // Obtenir la valeur actuelle de 'isDone'
    bool isDone = todoSnapshot.get("isDone");

    // Mettre à jour 'isDone' avec la valeur inverse
    await todoCollection.doc(uid).update({'isDone': !isDone});
  
      //await todoCollection.doc(uid).update({'isDone': true});
    
  }
    Future deleteTodoById(uid) async {
    
      await todoCollection.doc(uid).delete();
   
  }


 List<Todo> search(QuerySnapshot snapshot, String queryString) {
  return snapshot.docs
      .where((doc) =>
          (doc.get("todoText") ?? "").toLowerCase().contains(queryString.toLowerCase()))
      .map((e) {
    return Todo(
      isDone: e.get("isDone") ?? "",
      todoText: e.get("todoText") ?? "",
      uid: e.id,
    );
  }).toList();}


   Future addTodo(String title) async{

return await todoCollection.add({
        
        'todoText': title,
        'isDone': false,
      });
   }
   
     @override
     State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
     }

}


