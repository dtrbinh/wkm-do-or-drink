import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakumo_do_or_drink/features/home/home_screen_view.dart';

class DoOrDrinkApp extends StatelessWidget {
  const DoOrDrinkApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DO OR DRINK',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        fontFamily: 'Nunito',
        useMaterial3: true,
      ),
      home: const HomeView(title: 'DO OR DRINK'),
    );
  }
}
