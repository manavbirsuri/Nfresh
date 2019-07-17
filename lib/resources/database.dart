import 'dart:convert';
import 'dart:io';

import 'package:nfresh/models/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// database table and column names
final String tableCart = 'cart';

final String columnId = 'id';
final String columnName = 'name';
final String columnNameHindi = 'name_hindi';
final String columnImage = 'image';
final String columnDesc = 'description';
final String columnSku = 'sku';
final String columnUnitId = 'unit_id';
final String columnDisplayPrice = 'display_price_1';
final String columnInventory = 'inventory';
final String columnFav = 'fav';
final String columnPacking = 'packings';
final String columnSelectedPacking = 'selected_packing';
final String columnCount = 'count';

class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "n_fresh.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableCart (
                $columnId INTEGER,
                $columnName TEXT ,
                $columnNameHindi TEXT,
                $columnImage TEXT ,
                $columnDesc TEXT ,
                $columnSku TEXT ,
                $columnUnitId INTEGER ,
                $columnDisplayPrice INTEGER ,
                $columnInventory INTEGER,
                $columnFav TEXT,
                $columnPacking TEXT,
                $columnSelectedPacking TEXT ,
                $columnCount INTEGER 
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Product product) async {
    Database db = await database;
    print("INSERT: ${product.toJson()}");
    int id;
    try {
      id = await db.insert(tableCart, product.toJson());
      print("ID: $id}");
    } on DatabaseException catch (e) {
      print("ERROR: $e");
    }
    return id;
  }

  Future<int> update(Product product) async {
    Database db = await database;
    print("UPDATE: ${product.toJson()}");
    int id;
    try {
      id = await db.update(tableCart, product.toJson(),
          where: "id=? AND selected_packing=?",
          whereArgs: [product.id, jsonEncode(product.selectedPacking)]);
      print("ID: $id}");
    } on DatabaseException catch (e) {
      print("ERROR UPDATE: $e");
    }

    if (id == 0) {
      id = await insert(product);
    }
    return id;
  }

  Future<int> updateQuantity(Product product) async {
    Database db = await database;
    print("UPDATE: ${product.toJson()}");
    int id;
    try {
      id = await db.update(tableCart, product.toJson(),
          where: "id=? AND selected_packing=?",
          whereArgs: [product.id, jsonEncode(product.selectedPacking)]);
      print("ID: $id}");
    } on DatabaseException catch (e) {
      print("ERROR UPDATE: $e");
    }

    if (id == 0) {
      id = await insert(product);
    }
    return id;
  }

  Future<List<Product>> queryAllProducts() async {
    Database db = await database;
    List<Product> data = [];
    List<Map> maps = await db.query(tableCart);
    print("CartCOUNT: ${maps.length}");
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(Product.fromJson(maps[i]));
      }
    }
    return data;
  }

  Future<Product> queryConditionalProduct(Product product) async {
    Database db = await database;
    var _count = 0;
    List<Map> maps =
        await db.query(tableCart, where: "id=?", whereArgs: [product.id]);
    print("Product count : ${maps.length}");
    if (maps.length > 0) {
      return Product.fromJson(maps.first);
    }
    return null;
  }

  Future<int> getCartCount() async {
    Database db = await database;
    List<Map> maps = await db.query(tableCart);
    print("CartCOUNT: ${maps.length}");
    return maps.length;
  }

  Future remove(Product product) async {
    final db = await database;
    await db.delete(tableCart,
        where: "id=? AND selected_packing=?",
        whereArgs: [product.id, jsonEncode(product.selectedPacking)]);
  }

  Future clearCart() async {
    final db = await database;
    await db.delete(tableCart);
  }
}
