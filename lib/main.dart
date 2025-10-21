import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/users/presentation/screens/users_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReqRes Users',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: UsersListScreen(),
    );
  }
}
