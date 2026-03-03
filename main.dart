import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(home: TikTokApp(), debugShowCheckedModeBanner: false));

class FloatingLike {
  final Offset position;
  final double angle;
  final Key key = UniqueKey();
  FloatingLike({required this.position, required this.angle});
}

class TikTokApp extends StatefulWidget {
  const TikTokApp({super.key});
  @override
  State<TikTokApp> createState() => _TikTokAppState();
}

class _TikTokAppState extends State<TikTokApp> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildVideoFeed(),
          const Center(child: Text("المتجر الأبيض", style: TextStyle(color: Colors.white))),
          const Center(child: Text("الملف الشخصي", style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "المتجر"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "أنا"),
        ],
      ),
    );
  }

  Widget _buildVideoFeed() => PageView.builder(
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) => const VideoScreen(),
  );
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isLiked = false;
  List<FloatingLike> _likes = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) { setState(() {}); _controller.play(); _controller.setLooping(true); });
  }

  void _handleDoubleTap(Offset pos) {
    setState(() {
      _isLiked = true;
      _likes.add(FloatingLike(position: pos, angle: (pos.dx % 0.4) - 0.2));
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _likes.removeAt(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (d) => _handleDoubleTap(d.globalPosition),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized ? VideoPlayer(_controller) : const Center(child: CircularProgressIndicator()),
          ..._likes.map((l) => _buildHeart(l)),
          _buildSideBar(),
        ],
      ),
    );
  }

  Widget _buildHeart(FloatingLike l) => TweenAnimationBuilder(
    duration: const Duration(milliseconds: 800),
    tween: Tween<double>(begin: 0, end: 1),
    builder: (context, double v, child) => Positioned(
      left: l.position.dx - 50, top: l.position.dy - 100 - (v * 150),
      child: Opacity(opacity: 1 - v, child: Icon(Icons.favorite, color: Colors.red, size: 100 * (0.5 + v))),
    ),
  );

  Widget _buildSideBar() => Positioned(
    right: 15, bottom: 100,
    child: Column(
      children: [
        IconButton(icon: Icon(Icons.favorite, color: _isLiked ? Colors.red : Colors.white, size: 40), onPressed: () => setState(() => _isLiked = !_isLiked)),
        const Text("120K", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        const Icon(Icons.comment, color: Colors.white, size: 40),
        const Text("450", style: TextStyle(color: Colors.white)),
      ],
    ),
  );

  @override
  void dispose() { _controller.dispose(); super.dispose(); }
}
