import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/utils/todo.dart';

class TodoListItem extends StatelessWidget {
  final ToDo toDo;
  final Function(ToDo todo) onDelete;
  final Function(ToDo todo) onUpdate;
  const TodoListItem({ super.key, required this.toDo, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: .75,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext a){
                onDelete(toDo);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (BuildContext a){
                onUpdate(toDo);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.update,
              label: 'Update',
            ),
          ],
        ),
        child: Container(
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(DateFormat('dd/MM/yyyy - HH:mm').format(toDo.date)),
              Text(toDo.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ],
          ),
        ),
      ),
    );
  }
}
