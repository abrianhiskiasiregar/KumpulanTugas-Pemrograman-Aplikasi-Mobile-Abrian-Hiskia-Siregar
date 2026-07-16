import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = prefs.getBool('darkMode') ?? false;
      isLogin = prefs.getBool('loginStatus') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = !isDark;
    });

    await prefs.setBool(
      'darkMode',
      isDark,
    );
  }

  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLogin = value;
    });

    await prefs.setBool(
      'loginStatus',
      value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pink Notes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: isLogin
          ? HomePage(
              toggleTheme: toggleTheme,
              logout: () => setLogin(false),
            )
          : LoginPage(
              onLogin: () => setLogin(true),
            ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginPage({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 80,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Pink Notes",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          if (usernameController.text.isNotEmpty) {
                            onLogin();
                          }
                        },
                        child: const Text("LOGIN"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback logout;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.logout,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList("notes") ?? [];

    setState(() {
      notes = data
          .map(
            (e) => Note.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
    });
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      "notes",
      notes
          .map(
            (e) => jsonEncode(
              e.toJson(),
            ),
          )
          .toList(),
    );
  }

  Future<void> addNote(String title, String content) async {
    notes.add(
      Note(
        title: title,
        content: content,
      ),
    );

    await saveNotes();

    setState(() {});
  }

  Future<void> deleteNote(int index) async {
    notes.removeAt(index);

    await saveNotes();

    setState(() {});
  }

  Widget buildHome() {
    return notes.isEmpty
        ? const Center(
            child: Text(
              "Belum ada catatan",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        : ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    notes[index].title,
                  ),
                  subtitle: Text(
                    notes[index].content,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      deleteNote(index);
                    },
                  ),
                ),
              );
            },
          );
  }

  Widget buildProfile() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.pink,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Pink Notes User",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettings() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        onPressed: widget.logout,
        icon: const Icon(
          Icons.logout,
        ),
        label: const Text(
          "Logout",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    switch (currentIndex) {
      case 0:
        currentPage = buildHome();
        break;
      case 1:
        currentPage = buildProfile();
        break;
      default:
        currentPage = buildSettings();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pink Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: currentPage,
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.pink,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddNotePage(),
                  ),
                );

                if (result != null) {
                  await addNote(
                    result['title'],
                    result['content'],
                  );
                }
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.pink,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class AddNotePage extends StatelessWidget {
  const AddNotePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "Tambah Catatan",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Judul",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Isi Catatan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      contentController.text.isNotEmpty) {
                    Navigator.pop(
                      context,
                      {
                        'title': titleController.text,
                        'content': contentController.text,
                      },
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}