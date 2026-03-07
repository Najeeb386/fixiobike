import 'package:fixiobike/features/auth/screens/loginScreen.dart';
import 'package:fixiobike/features/dashboard/screens/homepage.dart';
import 'package:fixiobike/features/services/screens/serviceHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_colors.dart';
import 'features/services/screens/mainNavigationScreen.dart';

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
    return MaterialApp(
      title: 'Fixio Bike',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ServiceHomeScreen(),
    );
  }
}
