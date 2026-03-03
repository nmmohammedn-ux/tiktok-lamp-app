import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TikTokLamp(), debugShowCheckedModeBanner: false));

class TikTokLamp extends StatelessWidget {
  const TikTokLamp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb, size: 100, color: Colors.yellow),
            const SizedBox(height: 20),
            const Text("تطبيق المصباح الذكي", style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: const Text("تشغيل المصباح"),
            )
          ],
        ),
      ),
    );
  }
}
