import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelHomePage extends StatefulWidget {
  const ChannelHomePage({super.key});

  @override
  _ChannelHomePageState createState() => _ChannelHomePageState();
}

class _ChannelHomePageState extends State<ChannelHomePage> {
  int _currentIndex = 0;

  final List<String> _urls = [
    'https://iman-gadzhi.com/#ABOUT', // Home
    'https://www.youtube.com/channel/@ImanGadzhi/videos', // Videos
    'https://www.youtube.com/channel/@ImanGadzhi/playlists', // Playlists
    'https://www.youtube.com/channel/@ImanGadzhi/community', // Community
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0; // Initialize _currentIndex to the "Home" URL index
    _launchUrl(_urls[0]); // Launch the home page URL
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Iman Gadzhi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text("This is the channel homepage"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _launchUrl(_urls[index]); // Launch the corresponding URL
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
