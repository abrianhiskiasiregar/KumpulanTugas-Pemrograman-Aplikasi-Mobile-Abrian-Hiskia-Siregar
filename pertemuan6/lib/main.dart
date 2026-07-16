
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

//////////////////////////////////////////////////////
// APP ROOT
//////////////////////////////////////////////////////

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
      isDark = prefs.getBool('dark') ?? false;
      isLogin = prefs.getBool('login') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = !isDark;
    });

    prefs.setBool('dark', isDark);
  }

  Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLogin = value;
    });

    prefs.setBool('login', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: isLogin
          ? HomePage(toggleTheme: toggleTheme, logout: () => setLogin(false))
          : LoginPage(onLogin: () => setLogin(true)),
    );
  }
}

//////////////////////////////////////////////////////
// LOGIN PAGE
//////////////////////////////////////////////////////

class LoginPage extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 26)),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onLogin,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////
// HOME PAGE
//////////////////////////////////////////////////////

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
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> addNote(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();

    notes.add("$title - $content");

    await prefs.setStringList('notes', notes);

    setState(() {});
  }

  Future<void> deleteNote(int index) async {
    final prefs = await SharedPreferences.getInstance();

    notes.removeAt(index);

    await prefs.setStringList('notes', notes);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Storage App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.logout,
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(child: Text("Belum ada catatan"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(notes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteNote(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotePage(),
            ),
          );

          if (result != null) {
            await addNote(result['title'], result['content']);
          }
        },
      ),
    );
  }
}

//////////////////////////////////////////////////////
// ADD NOTE PAGE
//////////////////////////////////////////////////////

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: content,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                if (title.text.isNotEmpty && content.text.isNotEmpty) {
                  Navigator.pop(context, {
                    "title": title.text,
                    "content": content.text,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

