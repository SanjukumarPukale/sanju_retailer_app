import 'package:cart/model/ProductModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:cart/model/cart_model.dart';

class DBHelper {

  static Database? _db ;

  Future<Database?> get db async {
    if(_db != null){
      return _db!;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase()async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory() ;
    String path = join(documentDirectory.path , 'product.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate,);
    return db ;
  }

  _onCreate (Database db , int version )async{
    await db
        .execute('CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice REAL, productPrice REAL , quantity INTEGER, unitTag TEXT , image TEXT )');
    
    await db
        .execute('CREATE TABLE product (prodId VARCHAR PRIMARY KEY , prodName TEXT,prodPrice TEXT, prodImage TEXT, prodShortName TEXT )');
  }

  Future<Cart> insert(Cart cart)async{
    print(cart.toMap());
    var dbClient = await db ;
    await dbClient!.insert('cart', cart.toMap());
    return cart ;
  }

  Future<List<Products>> insertProduct(List<Products> productList)async{
    // print(product.toJson());
    var dbClient = await db ;
    // productList.forEach((element) async {
    //   await dbClient!.insert('product', element.toJson());
    //  });
     for(var item in productList) {
      try {
        await dbClient!.insert('product', item.toJson());
      } catch(e) {
        await updateProductQuantity(item);
      }
      
     }
    // await dbClient!.insert('product', product.toJson());
    return productList;
  }

  Future<List<Cart>> getCartList()async{
    var dbClient = await db ;
    final List<Map<String , Object?>> queryResult =  await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();

  }

  Future<List<Products>> getProductList()async{
    var dbClient = await db ;
    final List<Map<String , Object?>> queryResult =  await dbClient!.query('product');
    return queryResult.map((e) => Products.fromJson(e)).toList();

  }

  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateQuantity(Cart cart)async{
    var dbClient = await db ;
    return await dbClient!.update(
        'cart',
        cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }

   Future<int> updateProductQuantity(Products item)async{
    var dbClient = await db ;
    return await dbClient!.update(
        'product',
        item.toJson(),
        where: 'prodId = ?',
        whereArgs: [item.prodId]
    );
  }
}