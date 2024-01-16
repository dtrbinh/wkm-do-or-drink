import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '2024/game/game_view.dart';

class DoOrDrinkApp extends StatelessWidget {
  const DoOrDrinkApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WAKUMO NEW YEAR PARTY 2023',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        fontFamily: 'Lobster',
        useMaterial3: true,
      ),
      home: const GameView(),
    );
  }
}
