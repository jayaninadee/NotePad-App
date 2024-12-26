import 'package:flutter/material.dart';
import 'package:notepad/Pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:notepad/Themes/themesprovider.dart';
import 'Databases/notes_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDbService.initializeDb();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesDbService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: themeProvider.getTheme(),
      home: const Home(),
    );
  }
}
