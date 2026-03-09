import 'package:fixiobike/core/bindings/app_bindings.dart';
import 'package:fixiobike/features/dashboard/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const FixioBikeApp());
}

class FixioBikeApp extends StatelessWidget {
  const FixioBikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fixio Bike',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBindings(),
      home: const Homepage(),
    );
  }
}
