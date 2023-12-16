import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Constantes/Colors.dart';
import 'package:my_app/Model/FirebaseService.dart';
import 'package:my_app/Model/todo.dart';
import 'package:my_app/loading.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  
  @override
  State<Home> createState() => HomeState();
  

}
  class HomeState extends State<Home>{
  List<Todo>? _foundToDo=[];
  List<Todo>? result=[];
  final _todoController = TextEditingController();
   final _searchController = TextEditingController();
 List<Todo>? todos;
 
  _runFilter() async {
 
var data=await FirebaseFirestore.instance.collection('todos').get();
setState(() {
  _foundToDo=data.docs.cast<Todo>();});} 
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(onSearchChanges);
  }
  onSearchChanges(){
    print(_searchController.text);
    searchResultList();
  }

  @override
  void dispose() {_searchController.removeListener(onSearchChanges);
  _searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
@override
  void didChangeDependencies() { _runFilter();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
   
  }

  searchResultList(){
    List<Todo>showResult=[];
    if(_searchController.text!=""){
for(var clientSnapchots in _foundToDo!){
  var todotext=clientSnapchots.todoText.toString().toLowerCase();
  if(todotext.contains(_searchController.text.toLowerCase()))
  {
    showResult.add(clientSnapchots);
  }
}
    }else{
      showResult=List.from(_foundToDo!);
    }
    setState(() {
      result=showResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: _buildAppBar(),
      body: SafeArea(

        child:
           StreamBuilder<List<Todo>>(
             stream:
             FirebaseService().todoList(),
             builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Loading();
              }
              List<Todo> todos=snapshot.data!;
              _foundToDo=todos;
        
               return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      children: [
Text('To do list',style: TextStyle(color: tdNoir,fontSize:30,fontWeight: FontWeight.w500),)   ,Divider(),                     Divider(),
                        SizedBox(height:20),
                        ListView.separated(
                          separatorBuilder:((context, index) => Divider(color: tdGris)),
                          shrinkWrap: true,
                          itemCount: result!.length,
                          itemBuilder: ((context, index) {
                          return Dismissible(
                            key: Key(_foundToDo![index].todoText),
                            background: Container(padding: EdgeInsets.only(left: 20),alignment: Alignment.centerLeft,child:Icon(Icons.delete),
                      color: Colors.white,
                    ),
                            onDismissed: (direction)async{ await  FirebaseService().deleteTodoById(result?[index].uid);
                            
                            },
                            child:  ListTile(
                  onTap: () {
                           FirebaseService().updateTodoIsDone(result?[index].uid);
                              },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  tileColor: Colors.white,
                  leading: Icon(
                    result![index].isDone ? Icons.check_box : Icons.check_box_outline_blank,
                    color: tdBlue,
                  ),
                  title: Text(
                    result![index].todoText,
                    style: TextStyle(
                      fontSize: 16,
                      color: tdNoir,
                      decoration: result![index].isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                
                ),
                          );               
           
                        } 
                        ))
                     , Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20, right: 20, left: 20,top:70),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _todoController,
                          decoration: InputDecoration(
                            hintText: 'Add a new to do item.',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, right: 20),
                      child: ElevatedButton(
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 40),
                        ),
                        onPressed: ()async {
                          if(_todoController.text.isNotEmpty){
                          //_addToDoItem(_todoController.text);
                         await FirebaseService().addTodo(_todoController.text.trim());
                         _todoController.clear();
 }},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tdBlue,
                          minimumSize: Size(60, 60),
                          elevation: 10,
                        ),
                      ),
                    )
                  ],
                ),
                     ), ],
                    ),
                  );
             }
           )));

            }
    
   /*  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child:  TextField(
         onChanged: (value) =>{
    
},
         
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: tdNoir,
                size: 20,
              ),
              prefixIconConstraints: BoxConstraints(
                maxHeight: 20,
                minWidth: 25,
              ),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: tdGris),
            ),
          ));
        }
      */
  

  AppBar _buildAppBar() {
    return AppBar(
       title:CupertinoSearchTextField(controller:_searchController),
       
      backgroundColor: tdBgColor,
      elevation: 0,
      //title: Text('To do list',style: TextStyle(color: tdNoir,fontSize:30,fontWeight: FontWeight.w500),),
      
    );
  }
 
  
  }
 /* void _handleToDoChange(Todo todo) async {
  // Update the local state
  setState(() {
    todo.isDone = !todo.isDone;
  });

  // Update the isDone field in Firebase
  try {
    await FirebaseService.updateTodoIsDone(todo.id!, todo.isDone);
  } catch (error) {
    print('Error updating isDone field in Firebase: $error');
    // Handle error as needed
  }
}

 void _deleteToDoItem(String id) async {
  // Remove locally
  List<Todo> currentToDoList = await toDoList;
  setState(() {
    currentToDoList.removeWhere((item) => item.id == id);
  });

  // Remove from Firebase
  try {
    await FirebaseService.deleteTodoById(id);
  } catch (error) {
    print('Error deleting todo from Firebase: $error');
    // Handle error as needed
  }
}

void _addToDoItem(String toDo) async {
  // Add locally
  setState(() {
    toDoList.then((list) {
      list.add(Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
  });

  // Add to Firebase
  try {
    await FirebaseService.addTodo(Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      todoText: toDo,
    ));
  } catch (error) {
    print('Error adding todo to Firebase: $error');
    // Handle error as needed
  }

  _todoController.clear();
}*/
 /*void _runFilter(String enteredKeyword) async {
  List<Todo> currentToDoList = await toDoList;

  Future<List<Todo>> res = Future.value([]);

  if (enteredKeyword.isEmpty) {
    res = Future.value(currentToDoList);
  } else {
    res = Future.value(currentToDoList
        .where((item) => item.todoText!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase()))
        .toList());
  }

  setState(() {
    _foundToDo = res;
  });
}*/


