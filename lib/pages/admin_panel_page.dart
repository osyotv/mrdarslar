import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _videoTitleController = TextEditingController();

  Future<void> _addVideo() async {
    if (_videoTitleController.text.isEmpty || _videoUrlController.text.isEmpty) return;
    
    // Youtubedan video ID ni olish
    String url = _videoUrlController.text;
    String videoId = "";
    if (url.contains("v=")) {
      videoId = url.split("v=")[1].split("&")[0];
    } else if (url.contains("youtu.be/")) {
      videoId = url.split("youtu.be/")[1].split("?")[0];
    } else {
      videoId = url; // Agar to'g'ridan to'g'ri ID kiritilsa
    }

    try {
      // Yangi video qo'shish
      await FirebaseFirestore.instance.collection('videos').add({
        'title': _videoTitleController.text,
        'video_id': videoId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Barchaga xabarnoma (alert) yuborish uchun notifications kolleksiyasini yangilaymiz
      await FirebaseFirestore.instance.collection('notifications').doc('latest_video').set({
        'title': _videoTitleController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _videoTitleController.clear();
      _videoUrlController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video qo'shildi va xabarnoma yuborildi!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xatolik: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADMIN PANEL', style: TextStyle(color: Colors.red)),
          iconTheme: const IconThemeData(color: Colors.red),
          bottom: const TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.people), text: "O'yinchilar"),
              Tab(icon: Icon(Icons.video_call), text: "Video Qo'shish"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // O'yinchilar ro'yxati
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').orderBy('total_score', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("O'yinchilar yo'q"));
                }
                final users = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index].data() as Map<String, dynamic>;
                    return Card(
                      color: const Color(0xFF111111),
                      shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFF333333)), borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.red)),
                        ),
                        title: Text("${u['first_name'] ?? 'User'} ${u['last_name'] ?? ''}", style: const TextStyle(color: Colors.white)),
                        subtitle: Text("Tel: ${u['phone'] ?? 'Yo\'q'}", style: const TextStyle(color: Colors.white54)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${u['total_score'] ?? 0} ball", style: const TextStyle(color: Color(0xFF00FF41), fontWeight: FontWeight.bold)),
                            Text("${u['unlocked_level'] ?? 1}-daraja", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Video qo'shish
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text("Yangi dars qo'shish barcha o'yinchilarga avtomatik tarzda xabarnoma (alert) yuboradi.", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _videoTitleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Video sarlavhasi (Mavzu)',
                      labelStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _videoUrlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'YouTube Video Linki',
                      labelStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _addVideo,
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text("Jo'natish", style: TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
