import 'package:flutter/material.dart';
import 'dart:async';
import 'custom_navbar.dart';
import 'animated_panels.dart';
import 'menu_page.dart'; // Menü sayfasını import ediyoruz

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  late Timer _timer;
  int _selectedIndex = 0;
  bool _showAnimation = false; // Asansör animasyonu için kontrol

  // Ürün verilerini içeren liste
  final List<Map<String, String>> _products = [
    {"image": "assets/gorsel_1.png", "price": "Iphone 15 Pro Max 87.899₺"},
    {"image": "assets/gorsel_2.png", "price": "Iphone 15 Pro Max Kılıf ₺500"},
    {"image": "assets/gorsel_3.png", "price": "Iphone Şarj Aleti 269₺"},
    {"image": "assets/gorsel_4.png", "price": "Airpods Pro (2. Nesil) 9350₺"},
    {"image": "assets/gorsel_5.png", "price": "Apple Watch SE 9999₺"},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % 3;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Alışgidiş sekmesine tıklandığında her zaman ana sayfaya yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onMiddleButtonTapped() {
    setState(() {
      _showAnimation = true; // Asansör animasyonu tetiklenir
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/welcome_banner.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Hangi katı gezmek istersin?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        _buildKatCard('assets/kat1.png', 0),
                        _buildKatCard('assets/kat2.png', 1),
                        _buildKatCard('assets/kat3.png', 2),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Neler yeni?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  Container(
                    height: 200,
                    child: PageView.builder(
                      itemCount: 4,
                      controller: PageController(viewportFraction: 0.95),
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        List<String> imagePaths = [
                          "assets/yeni1.png",
                          "assets/yeni2.png",
                          "assets/yeni3.png",
                          "assets/yeni4.png",
                        ];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0.0 : 5.0,
                            right: index == 2 ? 0.0 : 5.0,
                          ),
                          child: _buildAnimatedImage(imagePaths[index]),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  // "Senin için" bölümü
                  Text(
                    "Senin için",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(_products[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showAnimation)
            AnimatedPanels(
              onAnimationComplete: () {
                // Animasyon tamamlandıktan sonra Menü sayfasına yönlendirme yapılır
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex == 2
            ? -1
            : _selectedIndex, // Orta buton seçiliyken hiçbir sekme seçili olmaz
        onItemTapped: _onItemTapped,
        onMiddleButtonTapped: _onMiddleButtonTapped,
      ),
    );
  }

  Widget _buildAnimatedImage(String imagePath) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildKatCard(String imagePath, int index) {
    return Expanded(
      flex: _currentPage == index ? 7 : 2,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 3000),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        child: ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: _currentPage == index ? 1.0 : 0.7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Ürün kartını oluşturan widget
  Widget _buildProductCard(Map<String, String> product) {
    return Container(
      width: 160,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün görseli
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              image: DecorationImage(
                image: AssetImage(product["image"]!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Fiyat bilgisi
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              product["price"]!,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
