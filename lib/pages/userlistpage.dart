import 'package:flutter/material.dart';
import 'db_helper.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    _users = await _dbHelper.getAllUsers(); // Carga todos los usuarios
    setState(() {}); // Actualiza la UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: _users.isEmpty
          ? const Center(child: Text('No hay usuarios registrados.'))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['name']),
            subtitle: Text(user['email']),
          );
        },
      ),
    );
  }
}
