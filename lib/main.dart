import 'package:flutter/material.dart';
import 'screens/ana_sayfa.dart'; // ana_sayfa.dart dosyasını içe aktardık
import 'screens/animated_panels.dart';
import 'screens/menu_page.dart';
import 'screens/finger_bot.dart'; // finger_bot.dart dosyasını içe aktardık

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Uygulaması',
      theme: ThemeData(
        brightness: Brightness.dark, // Siyah tema kullanımı
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/', // Başlangıç rotası
      routes: {
        '/': (context) => MainPage(), // Ana Sayfa
        '/menu': (context) => MenuPage(), // Menü Sayfası
        '/finger_bot': (context) => FingerBotPage(), // FingerBot Sayfası
      },
      debugShowCheckedModeBanner: false, // Debug bayrağını gizleme
    );
  }
}
