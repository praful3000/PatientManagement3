import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_management/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Patient Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffFFB116)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          primarySwatch: Colors.blue,
          fontFamily: "Poppins"),
      initialRoute: GetRoutes.allPatients,
      getPages: GetRoutes.routes,
    );
  }
}
