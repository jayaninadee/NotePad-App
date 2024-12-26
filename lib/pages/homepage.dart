import 'package:flutter/material.dart';
import 'package:notepad/Components/tile.dart';
import 'package:notepad/Databases/notes_db.dart';
import 'package:notepad/Entites/note.dart';
import 'package:notepad/Themes/dark.dart';
import 'package:notepad/Themes/themesprovider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<NotesDbService>().readNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N O T E S'),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColor),
            child: Builder(builder: (context) {
              return  Center(
                  child: Text('The Menu',
                      style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 24)));
            }),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.getTheme() == darkTheme,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
              Navigator.pop(context); // Close the drawer
            },
            secondary: const Icon(Icons.brightness_6),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<NotesDbService>(
      builder: (context, notesDb, child) {
        List<Note> notes = notesDb.getNotes();
        return notes.isEmpty
            ? const Center(child: Text('Let\'s make a Note!'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return MyTile(
                    noteId: note.id,
                    text: note.text!,
                    editingFun: () => _showEditNoteDialog(note),
                    deletingfun: () => _showDeleteNoteDialog(note.id),
                    // deletingfun: () => notesDb.deleteNote(note.id),
                  );
                },
              );
      },
    );
  }

  void _showCreateNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create a note'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _noteController,
            validator: (value) =>
                value == null || value.isEmpty ? 'Note cannot be empty' : null,
          ),
        ),
        actions: [
          _dialogButton(context, 'Cancel', () {
            _noteController.clear();
            Navigator.pop(context);
          }),
          _dialogButton(context, 'Create', () {
            if (_formKey.currentState?.validate() ?? false) {
              context.read<NotesDbService>().addNotes(_noteController.text);
              _noteController.clear();
              Navigator.pop(context);
            }
          }),
        ],
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    _editController.text = note.text ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Note'),
        content: TextField(controller: _editController),
        actions: [
          _dialogButton(context, 'Cancel', () {
            _editController.clear();
            Navigator.pop(context);
          }),
          _dialogButton(context, 'Update', () {
            context
                .read<NotesDbService>()
                .updateNote(note.id, _editController.text);
            _editController.clear();
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }



void _showDeleteNoteDialog(int id) {
    showDialog(
        context: context,
        builder:(context) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog without deleting
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Proceed to delete the note
                context.read<NotesDbService>().deleteNote(id);
                Navigator.pop(context);  // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        ),
    );
}

  Widget _dialogButton(
  BuildContext context, String text, VoidCallback onPressed) {
  return TextButton(
  onPressed: onPressed,
  child: Text(text),
  );
  }
}