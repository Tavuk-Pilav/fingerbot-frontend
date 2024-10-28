import 'package:alisgidis/screens/animated_panels.dart'; // AnimatedPanels importu
import 'package:flutter/material.dart';
import 'custom_navbar.dart'; // Navbar importu
import 'animated_panels_open.dart'; // AnimatedPanelsOpen importu

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF010204), // Arka plan siyah olacak
      body: Stack(
        children: [
          // Sayfanın geri kalan içeriği
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst kısımdaki kat belirten resim
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40.0), // Üstten biraz boşluk bırakıyoruz
                  child: Image.asset(
                    'assets/ust_resim.png', // Üst resim
                    fit: BoxFit.contain, // Ekrana uygun yerleşim
                    height: 60, // Yüksekliği ayarladık
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "BU ASANSÖRDE ÖNCELİK HEP SENİN",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'assets/alt_resim.png', // Alt resim için kullandığımız dosya
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 10), // Araya boşluk bırakıyoruz
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF131313), // Siyah temalı arka plan rengi
                      border: Border.all(color: Color(0xFF232426), width: 2),
                      borderRadius: BorderRadius.circular(
                          16.0), // Kenarların yuvarlatılması
                    ),
                    padding: EdgeInsets.all(16.0), // İçerik boşluğu
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kat listesi
                        _buildKatListItem(
                          context,
                          "FİNGER BOT",
                          "4",
                          4,
                          Color(0xFF424244),
                          textColor: Colors.white,
                          text2Color: Colors.white,
                          subtitle: "OPEX-4U  /  TavukPilav",
                        ),
                        _buildKatListItem(
                          context,
                          "KONSEPT ALANLAR",
                          "3",
                          3,
                          Color(0xFF424244),
                          textColor: Colors.white,
                          text2Color: Colors.white,
                          subtitle: "Yaşam tarzına özel konsept mağazalar",
                        ),
                        _buildKatListItem(
                          context,
                          "DİJİTAL MAĞAZALAR",
                          "2",
                          2,
                          Color(0xFF424244),
                          textColor: Colors.white,
                          text2Color: Colors.white,
                          subtitle: "Sevdiğin markaların dijital mağazaları",
                        ),
                        _buildKatListItem(
                          context,
                          "YENİLENMİŞ TELEFON",
                          "1",
                          1,
                          Color(0xFFD7FF01),
                          textColor: Colors.white, // Metin rengi beyaz
                          text2Color: Color(0xFFD7FF01),
                          subtitle: "Popüler markaların yenilenmiş telefonları",
                        ),
                        _buildKatListItem(
                          context,
                          "ALIŞGİDİŞ",
                          "G",
                          4,
                          Color(0xFF424244),
                          textColor: Colors.white,
                          text2Color: Colors.white,
                          subtitle: "Yeni teknolojiler ve FingerBot çözümleri",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Kapı açılma animasyonu
          AnimatedPanelsOpen(),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0,
        onItemTapped: (int index) {
          if (index == 0) {
            // Alışgidiş butonuna tıklandığında ana sayfaya dönme
            Navigator.of(context).pushNamed('/');
          }
        },
        onMiddleButtonTapped: () {
          // Ortadaki butona basıldığında
          Navigator.of(context).pushNamed('/menu');
        },
      ),
    );
  }

  // Katlar için liste elemanları oluşturan fonksiyon
  Widget _buildKatListItem(BuildContext context, String title, String number,
      int katIndex, Color color,
      {required Color textColor, // TextColor parametresi
      required String subtitle, // Subtitle parametresi
      required Color text2Color}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 3.0),
      leading: Icon(
        Icons.circle,
        color: color,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor, // Dinamik metin rengi
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle, // Alt metin
        style: TextStyle(
          color: Colors.grey, // Alt metin için sabit gri renk
          fontSize: 10,
        ),
      ),
      trailing: CircleAvatar(
        backgroundColor: Color(0xFF3f3f40),
        child: Text(
          number,
          style: TextStyle(
            color: text2Color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: katIndex == 1
          ? () {
              // Yenilenmiş telefon merkezi için yönlendirme
              Navigator.pushNamed(context, '/');
            }
          : katIndex == 4
              ? () {
                  // FingerBot katına tıklandığında önce animasyon çalışacak
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AnimatedPanels(
                        onAnimationComplete: () {
                          // Animasyon tamamlandıktan sonra FingerBot sayfasına geçiş yapılır
                          Navigator.pushNamed(context, '/finger_bot');
                        },
                      ),
                    ),
                  );
                }
              : null, // Diğer katlara yönlendirme yok
    );
  }
}
