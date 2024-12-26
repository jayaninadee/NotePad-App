import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notepad/Entites/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDbService extends ChangeNotifier {
  static late Isar isar;
  static List<Note> currentNotes = [];

  //Initialize the database
  static Future<void> initializeDb() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: directory.path);
  }

// Add notes to the database
  Future<void> addNotes(String text) async {
    final Note note = Note()..text = text = text;
    await isar.writeTxn(() async {
      isar.notes.put(note);
    });
    await readNotes();
  }

  // Read all notes from the database
  Future<void> readNotes() async {
    List<Note> mynotes = await isar.notes.where().findAll();
    currentNotes.clear(); // Clear previous notes
    currentNotes.addAll(mynotes);
    notifyListeners();
  }

  // Update a note in the database
  Future<void> updateNote(int id, String newtext) async {
    await isar.writeTxn(() async {
      final note = await isar.notes.get(id);
      if (note != null) {
        note.text = newtext;
        await isar.notes.put(note);
        
      }
    });
    await readNotes();
  }

  // Delete a note from the database
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      isar.notes.delete(id);
    });
    await readNotes();
  }

  List<Note> getNotes() {
    return currentNotes;
  }
   
 final Set<int> _checkedNoteIds = {};
   // Toggle the checked state of a note
  void toggleNoteChecked(int id) {
    if (_checkedNoteIds.contains(id)) {
      _checkedNoteIds.remove(id);
    } else {
      _checkedNoteIds.add(id);
    }
    notifyListeners();
  }

  bool isNoteChecked(int id) {
    return _checkedNoteIds.contains(id);
  }


}
