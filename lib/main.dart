import 'package:cart/provider/cart_provider.dart';
import 'package:cart/firebase_options.dart';
import 'package:cart/view/product_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(
       create: (_) => CartProvider(),
     child: Builder(builder: (BuildContext context){
       return MaterialApp(
         title: 'Flutter Demo',
         debugShowCheckedModeBanner: false,
         theme: ThemeData(
           primarySwatch: Colors.blue,
         ),
         home: const ProductListScreen(),
       );
     }),

   );
  }
}

