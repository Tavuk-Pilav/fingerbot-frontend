import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'animated_panels.dart';
import 'animated_panels_open.dart';
import 'custom_navbar.dart';
import 'package:flutter/material.dart';


class FingerBotPage extends StatefulWidget {
  @override
  _FingerBotPageState createState() => _FingerBotPageState();
}

class _FingerBotPageState extends State<FingerBotPage> {
  List<Map<String, String>> _messages = [];
  TextEditingController _controller = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _voiceInput = '';

  @override
  void initState() {
    super.initState();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _voiceInput = val.recognizedWords;
          _controller.text = _voiceInput;
        });
      });
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _sendMessage() {
    String userMessage = _controller.text;

    // Kullanıcı mesajını hemen göster
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"user": userMessage});
        _controller.clear();
      });

      // 3 saniyelik gecikme ile bot cevabını gönder
      Future.delayed(Duration(seconds: 3), () {
        if (userMessage == "Ortaokula giden oğlum için telefon alcam. Orta halli telefonlar öner") {
          setState(() {
            _messages.add({"bot": "Tabii efendim size özel ürünlerimizi sunuyorum"});
            _messages.add({"bot": "cards"});
          });
        } else {
          sendMessageToLambda(userMessage).then((botResponse) {
            setState(() {
              _messages.add({"bot": botResponse});
            });
          }).catchError((error) {
            setState(() {
              _messages.add({"bot": "Bir hata oluştu: $error"});
            });
            debugPrint('Lambda API çağrısında hata oluştu: $error');
          });
        }
      });
    }
  }

  Future<String> sendMessageToLambda(String userMessage) async {
    final url = 'https://52wqx8pun7.execute-api.us-west-2.amazonaws.com/yine-deniyoruz';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': 'Proddeneme6',
          'query': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Lambda API yanıtı: $data');

        if (data != null && data['body'] != null) {
          final bodyData = jsonDecode(data['body']);
          if (bodyData != null && bodyData['response'] != null) {
            return bodyData['response'];
          }
        }
        debugPrint('Lambda API yanıtı geçersiz yapıda: $data');
        return "Claude'dan geçersiz yanıt alındı.";
      } else {
        debugPrint('Lambda API hatası, durum kodu: ${response.statusCode}');
        return "Claude'dan cevap alınamadı, durum kodu: ${response.statusCode}.";
      }
    } catch (e) {
      debugPrint('Lambda API çağrısı sırasında bir hata oluştu: $e');
      return "Bir hata oluştu: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/fingerbot_avatar.png'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text(
                "FingerBot Katı ",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isUser = _messages[index].containsKey("user");
                      String message = isUser
                          ? _messages[index]["user"]!
                          : _messages[index]["bot"]!;

                      if (message == "cards") {
                        return _buildCardCarousel();
                      }

                      return ListTile(
                        title: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Color(0xFFD4FA1B)
                                  : Color(0xFF8D3487),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    backgroundImage: AssetImage('assets/fingerbot_avatar.png'),
                                    radius: 15,
                                  ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    message,
                                    style: TextStyle(color: isUser ? Colors.black : Colors.white),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Mesaj yaz...",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color(0xFF232426),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AnimatedPanelsOpen(),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: -1,
          onItemTapped: (int index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimatedPanels(
                    onAnimationComplete: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
              );
            }
          },
          onMiddleButtonTapped: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AnimatedPanels(
                  onAnimationComplete: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardCarousel() {
    return Container(
      height: 270,
      color: Colors.black,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCard(
            'assets/gorsell1.png',
            'Xiaomi Redmi Note 13 Pro \n               14,499 TL',
            '4.6/5',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UrunDetaySayfasi()),
              );
            },
          ),
          
          _buildCard('assets/gorsell2.png', '     Realme 12+ \n     13499 TL', '4.5/5'),
          _buildCard('assets/gorsell3.png', 'Samsung Galaxy A35 \n           13999 TL', '4.4/5'),
        ],
      ),
    );
  }

  Widget _buildCard(String imagePath, String price, String rating, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 250, // Kart genişliği
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white, // Arka planı beyaz yapıyoruz
        child: Column(
          mainAxisSize: MainAxisSize.min, // Yükseklik içeriğe göre ayarlanacak
          children: [
            Image.asset(imagePath, height: 150),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Yazı rengi siyah
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                rating,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Yazı rengi siyah
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class UrunDetaySayfasi extends StatelessWidget {
  // Örnek olumlu ve olumsuz yorumlar listesi
  final List<String> olumluYorumlar = [
    "Harika performans, tam fiyat/performans telefonu!",
    "Kamera kalitesi oldukça iyi.",
    "Hızlı şarj özelliği gerçekten çok işe yarıyor.",
    "Ekran kalitesi mükemmel.",
    "Batarya ömrü uzun ve dayanıklı."
  ];

  final List<String> olumsuzYorumlar = [
    "Düşük ışıkta kamera performansı pek iyi değil.",
    "Yazılım arayüzü biraz karmaşık.",
    "Cihaz biraz ağır hissediliyor.",
    "Uzun süreli kullanımda ısınma sorunu yaşıyorum.",
    "Güncellemeler biraz geç geliyor."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Detayı'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Önceki ekrana dön
          },
        ),
      ),
      body: SingleChildScrollView( // Taşmayı önlemek ve kaydırılabilir yapmak için eklendi
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/gorsell1.png'), // Ürün görseli
              SizedBox(height: 20),
              Text(
                'Xiaomi Redmi Note 13 Pro', // Ürün başlığı
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Metni ortalamak için eklendi
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Özellikler:\n'
                  '• 6.67 inç AMOLED Ekran\n'
                  '• Snapdragon 7 Gen 1 işlemci\n'
                  '• 12 GB RAM, 256 GB depolama\n'
                  '• 108 MP ana kamera, 16 MP ön kamera\n'
                  '• 5000 mAh batarya, 67W hızlı şarj\n'
                  '• 5G desteği\n'
                  '• Uygun fiyat ve güçlü performans',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            
              SizedBox(height: 20),
              // Olumlu Yorumlar Başlığı
              Text(
                'Olumlu Yorumlar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Olumlu Yorumlar Kartları
              Column(
                children: olumluYorumlar.map((yorum) => _buildYorumCard(yorum, Colors.green)).toList(),
              ),
              SizedBox(height: 20),
              // Olumsuz Yorumlar Başlığı
              Text(
                'Olumsuz Yorumlar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Olumsuz Yorumlar Kartları
              Column(
                children: olumsuzYorumlar.map((yorum) => _buildYorumCard(yorum, Colors.red)).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Satın alma işlemi veya sepete ekleme fonksiyonu buraya eklenecek
                  print('Satın Al butonuna basıldı!');
                },
                child: Text('Satın Al'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Yorum Kartlarını oluşturacak fonksiyon
  Widget _buildYorumCard(String yorum, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(Icons.comment, color: color),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                yorum,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

