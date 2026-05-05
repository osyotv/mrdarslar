import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  final List<Map<String, dynamic>> lessons = const [
    {"title": "1-Dars: Python O'rnatish va Print", "duration": "10:25", "level": 1},
    {"title": "2-Dars: O'zgaruvchilar va Turlar", "duration": "14:10", "level": 1},
    {"title": "3-Dars: Matematik amallar", "duration": "09:45", "level": 1},
    {"title": "4-Dars: List, Set, Tuple", "duration": "22:15", "level": 2},
    {"title": "5-Dars: If, Else, Elif", "duration": "18:30", "level": 3},
    {"title": "6-Dars: For va While sikllari", "duration": "25:00", "level": 4},
  ];

  void _playVideo(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.ondemand_video, size: 100, color: Color(0xFF26D0CE)),
            SizedBox(height: 20),
            Text(
              "Video hozircha faqat Premium obunachilar uchun yoki serverda yuklanmoqda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yopish", style: TextStyle(color: Color(0xFF26D0CE))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Darslar')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Barcha Darslar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Premium sifatdagi video qo'llanmalar", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: const Icon(Icons.play_circle_fill, size: 40, color: Color(0xFF26D0CE)),
                      ),
                      title: Text(lesson['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Davomiyligi: ${lesson['duration']} | ${lesson['level']}-daraja", style: const TextStyle(color: Colors.white54)),
                      trailing: IconButton(
                        icon: const Icon(Icons.download_rounded, color: Colors.white54),
                        onPressed: () {},
                      ),
                      onTap: () => _playVideo(context, lesson['title']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
