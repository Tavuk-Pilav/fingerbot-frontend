import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onMiddleButtonTapped; // Ortadaki buton için callback

  const CustomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onMiddleButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          height: 80.0,
          decoration: BoxDecoration(
            color: Color(0xFF18191b),
            border: Border.all(color: Color(0xFF232426), width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Color(0xFFD7FF01),
            unselectedItemColor: Color(0xFF494d53),
            currentIndex: selectedIndex == -1
                ? 0
                : selectedIndex, // Orta buton seçiliyken hiçbir sekme seçili olmaz
            onTap: onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Alışgidiş",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Arama",
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Orta buton için boş yer bırakıyoruz
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: "Sepet",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profil",
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25.0,
          child: GestureDetector(
            onTap: onMiddleButtonTapped, // Orta buton tıklanma fonksiyonu
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/ortadaki_buton.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
