// main.dart
// Entry point: initializes Hive and runs the app.
// Flutter 3.29 compatible.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_note/ui/main_home_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app_bindings.dart';
import 'ui/exchange_screen.dart';

/// The entry point of the application.
///
/// This function initializes the Flutter bindings, Hive for local storage,
/// and sets the system UI overlay style before running the app.
Future<void> main() async {
  // Ensure that the Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local data storage.
  await Hive.initFlutter();
  // Open a box for app data.
  await Hive.openBox('konvbox');

  // Set the system UI overlay style for the entire app.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set status bar color to white.
    statusBarIconBrightness: Brightness.dark, // Use dark icons for light background.
  ));

  // Run the root widget of the application.
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ResponsiveSizer to make the app responsive to different screen sizes.
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        // Use GetMaterialApp for state management and routing.
        return GetMaterialApp(
          title: 'Price Quote',
          debugShowCheckedModeBanner: false,
          initialBinding: AppBindings(),
          // getPages: AppRoutes.pages,
          // Define the theme for the application.
          theme: ThemeData(
            primaryColor: const Color(0xFF2FCC93),
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF2FCC93)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // Set the home screen of the application.
          home: const MainHomeScreen(),
        );
      },
    );
  }
}
