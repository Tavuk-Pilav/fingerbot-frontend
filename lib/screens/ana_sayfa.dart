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
}
