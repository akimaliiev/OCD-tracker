import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:ocr_2/auth/auth_gate.dart';
import 'package:ocr_2/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
@override
void initState() {
  _loadAssets();
}

Future<void> _loadAssets() async {
  try {
    final googlePayAsset = await rootBundle.loadString('assets/google_pay.json');
    final applePayAsset = await rootBundle.loadString('assets/apple_pay.json');
    print('Google Pay config: $googlePayAsset');
    print('Apple Pay config: $applePayAsset');
  } catch (e) {
    print('Error loading assets: $e');
  }
}
