import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart/model/cart_model.dart';
import 'package:cart/provider/cart_provider.dart';
import 'package:cart/controller/getProductController.dart';
import 'package:cart/db/db_helper.dart';
import 'package:cart/model/ProductModel.dart';
import 'package:cart/view/cart_screen.dart';
import 'package:cart/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  // List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  // List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  // List<String> productImage = [
  //   'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
  //   'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
  //   'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
  //   'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
  //   'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
  //   'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
  //   'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  // ] ;

  DBHelper? dbHelper = DBHelper();
  // List productList = [];
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    isLoading = true;

    getProduct();
    super.initState();
  }

  insertProductToDB() async {
    await dbHelper!.insertProduct(productsList);
  }

  getProductFromDB() async {
    productsListFromDB = await dbHelper!.getProductList();
  }

  List<Products> productsList = [];
  List<Products> productsListFromDB = [];

  getProduct() async {
    var data = await ProductController().getProduct();
    productsList = data.data!.products!;
    print(productsList);
    await insertProductToDB();
    await getProductFromDB();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
              onTap: () {
                logOut();
              },
              child: Icon(Icons.logout)),
        automaticallyImplyLeading: false,
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          SizedBox(width: 20.0),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: productsListFromDB.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Image(
                                    //   height: 100,
                                    //   width: 100,
                                    //   image: NetworkImage(productsList[index].prodImage!),
                                    // ),
                                    CachedNetworkImage(
                                      height: 100,
                                      width: 100,
                                      imageUrl:
                                          productsListFromDB[index].prodImage!,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productsListFromDB[index].prodName!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '₹' +
                                                productsListFromDB[index]
                                                    .prodPrice!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                // print(index);
                                                // print(index);
                                                // print(productName[index].toString());
                                                // print( productPrice[index].toString());
                                                // print( productPrice[index]);
                                                // print('1');
                                                // print(productUnit[index].toString());
                                                // print(productImage[index].toString());

                                                dbHelper!
                                                    .insert(Cart(
                                                        id: index,
                                                        productId:
                                                            index.toString(),
                                                        productName:
                                                            productsListFromDB[
                                                                    index]
                                                                .prodName!,
                                                        initialPrice: double.parse(
                                                            productsListFromDB[
                                                                    index]
                                                                .prodPrice!),
                                                        productPrice: double.parse(
                                                            productsListFromDB[
                                                                    index]
                                                                .prodPrice!),
                                                        quantity: 1,
                                                        unitTag: '',
                                                        image:
                                                            productsListFromDB[
                                                                    index]
                                                                .prodImage!))
                                                    .then((value) {
                                                  cart.addTotalPrice(
                                                      double.parse(
                                                          productsListFromDB[
                                                                  index]
                                                              .prodPrice!));
                                                  cart.addCounter();

                                                  final snackBar = SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                        'Product is added to cart'),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }).onError((error, stackTrace) {
                                                  print("error" +
                                                      error.toString());
                                                  final snackBar = SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          'Product is already added in cart'),
                                                      duration:
                                                          Duration(seconds: 1));

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: const Center(
                                                  child: Text(
                                                    'Add to cart',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  Future<void> logOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('We will be redirected to login page.'),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the Dialog
                      },
                    ),
                    ElevatedButton(
                      child: Text('Yes'),
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => PhoneLoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
