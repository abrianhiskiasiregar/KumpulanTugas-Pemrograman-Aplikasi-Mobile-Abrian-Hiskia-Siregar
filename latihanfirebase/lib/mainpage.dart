import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'services/database_service.dart';
import 'models/supporter_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(user: snapshot.data!);
          }
          if (showLoginPage) {
            return LoginScreen(showRegisterPage: toggleScreens);
          } else {
            return RegisterScreen(showLoginPage: toggleScreens);
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOME SCREEN (Dashboard setelah login)
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _showFormDialog({Supporter? supporter}) {
    final isEdit = supporter != null;

    if (isEdit) {
      _nameController.text = supporter.name;
      _roleController.text = supporter.role;
      _phoneController.text = supporter.phoneNumber;
    } else {
      _nameController.clear();
      _roleController.clear();
      _phoneController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEdit ? 'EDIT SUPPORTER' : 'ADD NEW SUPPORTER',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFC8102E),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Role (e.g. Anggota/Core)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8102E),
            ),
            onPressed: () async {
              String name = _nameController.text.trim();
              String role = _roleController.text.trim();
              String phone = _phoneController.text.trim();

              if (name.isEmpty || role.isEmpty || phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields!'),
                    backgroundColor: Color(0xFFC8102E),
                  ),
                );
                return;
              }

              final newSupporter = Supporter(
                name: name,
                role: role,
                phoneNumber: phone,
              );

              if (isEdit) {
                await _dbService.updateSupporter(supporter.id!, newSupporter);
              } else {
                await _dbService.addSupporter(newSupporter);
              }

              if (mounted) Navigator.pop(context);
            },
            child: Text(
              isEdit ? 'UPDATE' : 'SUBMIT',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'ANFIELD ROAD - DASHBOARD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
        backgroundColor: const Color(0xFFC8102E),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Welcome Banner ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF6EB61),
            child: Column(
              children: [
                const Text(
                  "WELCOME TO USTB FC DATABASE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC8102E),
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Logged in as: ${widget.user.email}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),

          // ── Supporter List ──
          Expanded(
            child: StreamBuilder<List<Supporter>>(
              stream: _dbService.getSupportersStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC8102E)),
                  );
                }

                final supporters = snapshot.data ?? [];

                if (supporters.isEmpty) {
                  return const Center(
                    child: Text(
                      "No supporters registered yet.\nTap '+' to add.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: supporters.length,
                  itemBuilder: (context, index) {
                    final supporter = supporters[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFC8102E),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          supporter.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Role: ${supporter.role}\nPhone: ${supporter.phoneNumber}",
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () =>
                                  _showFormDialog(supporter: supporter),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFC8102E),
                              ),
                              onPressed: () =>
                                  _dbService.deleteSupporter(supporter.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC8102E),
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
