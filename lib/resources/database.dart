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
final String columnPacking = 'packing';
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
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnNameHindi TEXT NOT NULL,
                $columnImage TEXT NOT NULL,
                $columnDesc TEXT NOT NULL,
                $columnSku TEXT NOT NULL,
                $columnUnitId INTEGER NOT NULL,
                $columnDisplayPrice INTEGER NOT NULL,
                $columnInventory INTEGER NOT NULL,
                $columnFav TEXT NOT NULL,
                $columnPacking TEXT NOT NULL,
                $columnSelectedPacking TEXT NOT NULL,
                $columnCount INTEGER NOT NULL,
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Product product) async {
    Database db = await database;
    int id = await db.insert(tableCart, product.toJson());
    return id;
  }

  /* Future<ModelProduct> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCart,
        columns: [columnId, columnWord, columnFrequency],
      //  where: '$columnId = ?',
       // whereArgs: [id]
        );
    if (maps.length > 0) {
      return ModelProduct.fromMap(maps.first);
    }
    return null;
  }*/
  Future<List<Product>> queryAllProducts() async {
    Database db = await database;
    List<Product> data = [];
    List<Map> maps = await db.query(tableCart);
    if (maps.length > 0) {
      data.add(Product(maps.first));
    }
    return data;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
