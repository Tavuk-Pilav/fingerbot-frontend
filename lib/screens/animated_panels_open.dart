import 'package:flutter/material.dart';

class AnimatedPanelsOpen extends StatefulWidget {
  @override
  _AnimatedPanelsOpenState createState() => _AnimatedPanelsOpenState();
}

class _AnimatedPanelsOpenState extends State<AnimatedPanelsOpen>
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

    _startPanelOpeningAnimation(); // Sayfa açılınca animasyon başlatılır
  }

  void _startPanelOpeningAnimation() async {
    // Yeni sayfa açılınca panel geri çekilerek açılır
    await _panelController.reverse(from: 1.0); // Paneller köşelere çekilir
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
