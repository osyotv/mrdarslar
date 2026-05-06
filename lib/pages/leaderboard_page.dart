import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Umumiy Reyting')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('total_score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Xatolik yuz berdi."));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Hozircha reyting bo'sh."));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final isFirst = index == 0;
              final String name = "${user['first_name'] ?? ''} ${user['last_name'] ?? ''}".trim();
              
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: isFirst ? Colors.amber.withOpacity(0.2) : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                  border: isFirst ? Border.all(color: Colors.amber, width: 2) : null,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isFirst ? Colors.amber : const Color(0xFF26D0CE),
                    child: isFirst
                        ? const Text("👑", style: TextStyle(fontSize: 20))
                        : Text("${index + 1}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    name.isEmpty ? "Foydalanuvchi" : name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: isFirst ? Colors.amber : Colors.white),
                  ),
                  subtitle: Text("${user['unlocked_level'] ?? 1}-daraja"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ball", style: TextStyle(color: Colors.white54, fontSize: 12)),
                      Text("${user['total_score'] ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
