// main.dart
// Entry point: initializes Hive and runs the app.
// Flutter 3.29 compatible.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_rate/ui/main_home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app_bindings.dart';
import 'routes.dart';
import 'ui/exchange_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await Hive.initFlutter();
  // Open a box for app data. Using Map storage for simplicity.
  await Hive.openBox('konvbox');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // 👈 set solid color (no transparency)
    statusBarIconBrightness: Brightness.dark, // 👈 dark icons for light background
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ResponsiveSizer wraps app for responsive sizing.
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Naira2Dollar',
          debugShowCheckedModeBanner: false,
          initialBinding: AppBindings(),
          // getPages: AppRoutes.pages,
          // Provide a simple theme
          theme: ThemeData(
            primaryColor: const Color(0xFF2FCC93),
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF2FCC93)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const MainHomeScreen(),
        );
      },
    );
  }
}
