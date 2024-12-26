import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notepad/Databases/notes_db.dart'; // Adjust import based on your project structure

class MyTile extends StatelessWidget {
  final String text;
  final int noteId; // Add noteId to identify which note this tile represents
  final Function() editingFun;
  final Function() deletingfun;

  const MyTile({
    super.key,
    required this.text,
    required this.noteId,
    required this.editingFun,
    required this.deletingfun,
  });

  @override
  Widget build(BuildContext context) {
    final notesDbService = Provider.of<NotesDbService>(context);
    bool isChecked = notesDbService.isNoteChecked(noteId);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor),
      child: ListTile(
        title: Flexible(
          child: RichText(
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              
              text: text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).primaryColorLight,
                decoration: isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Theme.of(context).primaryColorLight,
                decorationThickness: 2, // Adjust thickness as needed
              ),
            ),
          ),
        ),
        leading: Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            if (value != null) {
              notesDbService.toggleNoteChecked(noteId);
            }
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: editingFun,
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColorLight,
                )),
            IconButton(
              onPressed: deletingfun,
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
