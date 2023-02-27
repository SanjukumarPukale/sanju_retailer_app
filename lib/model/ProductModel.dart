 
class ProductModel {
  bool? status;
  String? message;
  Data? data;

  ProductModel({this.status, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Products>? products;

  Data({this.products});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? prodId;
  String? prodName; 
  String? prodPrice;
  String? prodImage;
  String? prodShortName;
  
  

  Products(
      {this.prodImage,
      this.prodId,
      this.prodName,
      this.prodShortName,
      this.prodPrice,
      });

  Products.fromJson(Map<String, dynamic> json) {
    prodImage = json['prodImage'];
    prodId = json['prodId'];
    prodName = json['prodName'];
    prodShortName = json['prodShortName'];
    prodPrice = json['prodPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodImage'] = this.prodImage;
    data['prodId'] = this.prodId;
    data['prodName'] = this.prodName;
    data['prodShortName'] = this.prodShortName;
    data['prodPrice'] = this.prodPrice;
    return data;
  }
}