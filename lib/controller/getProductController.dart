import 'dart:convert';

import 'package:cart/model/ProductModel.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<ProductModel> getProduct() async {
    final response = await http.get(Uri.parse('https://www.jsonkeeper.com/b/YIDG'));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200) {
      return ProductModel.fromJson(data);
    } else {
      return ProductModel.fromJson(data);
    }
  }
}