
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/model/note_data.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:provider/provider.dart';



class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
void  main() async{
  
  // initialize hive
  await Hive.initFlutter();

   // open a hive box
  await Hive.openBox('nota_database');

  runApp(MyApp());
  
}





  
class  MyApp extends StatelessWidget {

  const MyApp({super. key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){

    return ChangeNotifierProvider(
      create: (context)=> NotaData(),
      builder: (context, child) =>   MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(), 
        scrollBehavior: MyCustomScrollBehavior(),
        
      ),
      );
  
      }
}