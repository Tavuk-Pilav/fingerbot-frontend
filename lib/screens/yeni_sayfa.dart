import 'package:flutter/material.dart';

class YeniSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Sayfa'),
      ),
      body: Center(
        child: Text(
          'Asansör efekti ile bu sayfaya ulaştınız!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
