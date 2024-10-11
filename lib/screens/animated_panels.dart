import 'package:flutter/material.dart';

class AnimatedPanels extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const AnimatedPanels({required this.onAnimationComplete});

  @override
  _AnimatedPanelsState createState() => _AnimatedPanelsState();
}

class _AnimatedPanelsState extends State<AnimatedPanels>
    with TickerProviderStateMixin {
  late AnimationController _panelController;
  late Animation<double> _panelAnimation;

  @override
  void initState() {
    super.initState();

    // Sağ ve sol panel için tek bir animasyon kontrolcüsü
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // 1.5 saniye hız
    );

    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut, // Yavaş başla, yavaş bitir
    );

    _startPanelAnimation(); // Animasyonu başlat
  }

  void _startPanelAnimation() async {
    // İlk kapanma animasyonu (paneller kapanır)
    await _panelController.forward();

    // Paneller kapanınca yeni sayfaya yönlendir
    widget.onAnimationComplete(); // Sayfa geçişi animasyon bitmeden başlar

    // Biraz gecikme sonrası açılma animasyonu
    await Future.delayed(
        Duration(milliseconds: 300)); // Sayfa yüklendikten sonra biraz bekleme

    // Yeni sayfada paneller geri çekilerek açılır
    if (mounted) {
      await _panelController.reverse();
    }
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sol panelin animasyonu
        AnimatedBuilder(
          animation: _panelAnimation,
          builder: (context, child) {
            return Positioned(
              left: -MediaQuery.of(context).size.width /
                  2 *
                  (1 - _panelAnimation.value),
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/sol_panel.png'), // Sol panel görseli
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),

        // Sağ panelin animasyonu
        AnimatedBuilder(
          animation: _panelAnimation,
          builder: (context, child) {
            return Positioned(
              right: -MediaQuery.of(context).size.width /
                  2 *
                  (1 - _panelAnimation.value),
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/sag_panel.png'), // Sağ panel görseli
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
