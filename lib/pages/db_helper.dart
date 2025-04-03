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
      version: 11,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute(''' 
          CREATE TABLE cerdos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            identificacion TEXT,
            peso INTEGER,
            fecha_nacimiento TEXT, 
            etapa TEXT,
            raza TEXT,
            alimentacion TEXT
          )
        ''');
        await db.execute(''' 
          CREATE TABLE historial_salud(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cerdo_id INTEGER, 
          descripcion TEXT,
          FOREIGN KEY (cerdo_id) REFERENCES cerdos (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Insertar un usuario (Registro)
  Future<bool> registerUser(String name, String email, String password) async {
    final db = await database;
    Map<String, dynamic> user = {
      'name': name,
      'email': email,
      'password': password,
    };

    // Retornar true si se inserta correctamente
    int result = await db.insert('usuarios', user);
    return result > 0;
  }

  // Verificar usuario (Login)
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('usuarios'); // Devuelve todos los registros de la tabla 'usuarios'
  }

  // Insertar un cerdo en la base de datos
  Future<int> addCerdo(String identificacion, double peso, String fechaNacimiento, String etapa, String raza, String alimentacion) async {
    final db = await database;
    Map<String, dynamic> cerdo = {
      'identificacion': identificacion,
      'peso': peso,
      'fecha_nacimiento': fechaNacimiento,
      'etapa': etapa,
      'raza': raza,
      'alimentacion': alimentacion,
    };
    return await db.insert('cerdos', cerdo);
  }

  // Obtener todos los cerdos
  Future<List<Map<String, dynamic>>> getAllCerdos() async {
    final db = await database;
    return await db.query('cerdos'); // Devuelve todos los registros de la tabla 'cerdos'
  }

  // Método para eliminar un cerdo por su ID
  Future<int> deleteCerdo(int id) async {
    final db = await database;
    return await db.delete(
      'cerdos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Método para verificar si un cerdo con el mismo ID ya existe
  Future<bool> existeCerdo(String identificacion) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'cerdos',
      where: 'identificacion = ?',
      whereArgs: [identificacion],
    );
    return result.isNotEmpty;
  }
  // Obtener un cerdo específico por su ID
  Future<Map<String, dynamic>?> getCerdoById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'cerdos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first; // Retorna los datos del cerdo encontrado
    }
    return null; // Retorna null si no se encuentra el cerdo
  }
  // Método para actualizar un cerdo
  Future<int> updateCerdo(int id, double peso, String raza, String etapa) async {
    final db = await database;
    Map<String, dynamic> cerdo = {
      'peso': peso,
      'raza': raza,
      'etapa': etapa,
    };
    return await db.update(
      'cerdos',
      cerdo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
// Insertar historial de salud
  Future<int> addHistorialSalud(int cerdoId, String descripcion) async {
    final db = await database;
    Map<String, dynamic> historial = {
      'cerdo_id': cerdoId,
      'descripcion': descripcion,
    };
    return await db.insert('historial_salud', historial);
  }

  // Obtener historial de salud de un cerdo específico
  Future<List<Map<String, dynamic>>> getHistorialSalud(int cerdoId) async {
    final db = await database;
    return await db.query(
      'historial_salud',
      where: 'cerdo_id = ?',
      whereArgs: [cerdoId],
    );
  }

}

