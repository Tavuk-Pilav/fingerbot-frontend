import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP isteklerini yapabilmek için
import 'dart:convert'; // JSON işlemleri için ekliyoruz
import 'animated_panels.dart'; // AnimatedPanels importu
import 'animated_panels_open.dart'; // AnimatedPanelsOpen importu
import 'custom_navbar.dart'; // NavBar'ın import edilmesi

class FingerBotPage extends StatefulWidget {
  @override
  _FingerBotPageState createState() => _FingerBotPageState();
}

class _FingerBotPageState extends State<FingerBotPage> {
  List<Map<String, String>> _messages = []; // Mesajları tutan liste
  TextEditingController _controller = TextEditingController();

  // Mesaj gönderme fonksiyonu
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({"user": _controller.text}); // Kullanıcı mesajı ekle
        String userMessage = _controller.text;
        _controller.clear(); // Input'u temizle

        // Claude API'den cevap almak için
        sendMessageToClaude(userMessage).then((botResponse) {
          setState(() {
            _messages.add({"bot": botResponse}); // Bot mesajı ekle
          });
        }).catchError((error) {
          setState(() {
            _messages.add({"bot": "Bir hata oluştu!"}); // Hata durumunda mesaj
          });
          debugPrint('Claude API çağrısında hata oluştu: $error'); // Hata ayrıntıları
        });
      });
    }
  }

  // Claude API'ye HTTP isteği gönderen fonksiyon
  Future<String> sendMessageToClaude(String userMessage) async {
    final url = 'https://plxgs62vh0.execute-api.us-west-2.amazonaws.com/prod'; // API Gateway URL'niz
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Yanıtı kontrol et
        debugPrint('Claude API yanıtı: $data'); // Yanıtı logla

        if (data == null || data['response'] == null) {
          debugPrint('Claude API yanıtı boş veya geçersiz: $data');
          return "Claude'dan geçersiz yanıt alındı.";
        }

        return data['response']; // Claude'dan gelen yanıt
      } else {
        debugPrint('Claude API hatası, durum kodu: ${response.statusCode}');
        return "Claude'dan cevap alınamadı, durum kodu: ${response.statusCode}.";
      }
    } catch (e) {
      debugPrint('Claude API çağrısı sırasında bir hata oluştu: $e');
      return "Bir hata oluştu: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Geri tuşunu devre dışı bırakıyoruz
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Geri butonunu kaldırıyoruz
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    AssetImage('assets/fingerbot_avatar.png'), // FingerBot resmi
                radius: 20, // Görselin boyutu
              ),
              SizedBox(width: 10), // Görsel ve yazı arasına boşluk
              Text(
                "FingerBot Katı ~Elif ~Enes",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Mesajlar listesi
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      // Mesajları kullanıcı ve bot olarak ayırt et
                      bool isUser = _messages[index].containsKey("user");
                      String message = isUser
                          ? _messages[index]["user"]!
                          : _messages[index]["bot"]!;

                      return ListTile(
                        title: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Color(0xFF3f3f40)
                                  : Color(0xFF424244), // Kullanıcı ve bot için farklı renkler
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/fingerbot_avatar.png'), // FingerBot görseli
                                    radius: 15,
                                  ),
                                SizedBox(width: 8),
                                Expanded( // Text'i sığdırmak için Expanded kullanıyoruz
                                  child: Text(
                                    message,
                                    style: TextStyle(color: Colors.white),
                                    softWrap: true,
                                     // Uzun metinler "..." ile gösterilir
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
                // Mesaj yazma alanı
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
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
                      )
                    ],
                  ),
                )
              ],
            ),
            // Sayfa açılma animasyonu
            AnimatedPanelsOpen(), // Bu parametre onAnimationComplete almaz
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: -1, // Hiçbir sekmenin aktif olmaması için -1
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
