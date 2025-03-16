import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Método para obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'usuarios.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            role_encargado INTEGER DEFAULT 0,
            role_veterinario INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // Insertar un usuario (Registro)
  Future<bool> registerUser(String name, String email, String password, bool isEncargado, bool isVeterinario) async {
    final db = await database;
    Map<String, dynamic> user = {
      'name': name,
      'email': email,
      'password': password,
      'role_encargado': isEncargado ? 1 : 0,
      'role_veterinario': isVeterinario ? 1 : 0,
    };

    // Intentar insertar el usuario y retornar true si se inserta correctamente
    int result = await db.insert('usuarios', user);
    return result > 0; // Retorna true si se insertó con éxito
  }

  // Verificar usuario (Login) utilizando email y password
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty; // Retorna true si hay algún resultado
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('usuarios'); // Devuelve todos los registros de la tabla 'usuarios'
  }
}

