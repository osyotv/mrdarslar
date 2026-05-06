import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = true;
  int _userId = 0;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id') ?? 0;
    
    if (_userId > 0) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_userId.toString()).get();
      if (doc.exists) {
        final data = doc.data()!;
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _base64Image = data['avatar'];
      } else {
        _firstNameController.text = prefs.getString('first_name') ?? '';
        _lastNameController.text = prefs.getString('last_name') ?? '';
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    
    if (image != null) {
      setState(() => _isLoading = true);
      final bytes = await File(image.path).readAsBytes();
      final String base64String = base64Encode(bytes);
      
      setState(() {
        _base64Image = base64String;
      });
      
      if (_userId > 0) {
        await FirebaseFirestore.instance.collection('users').doc(_userId.toString()).set({
          'avatar': base64String
        }, SetOptions(merge: true));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    if (_userId > 0) {
      await FirebaseFirestore.instance.collection('users').doc(_userId.toString()).set({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
      }, SetOptions(merge: true));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('first_name', _firstNameController.text.trim());
      await prefs.setString('last_name', _lastNameController.text.trim());
    }
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil muvaffaqiyatli saqlandi!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF00FF41))));
    }

    final isAdmin = _phoneController.text.trim() == '914772377' || _phoneController.text.trim() == '+998914772377';

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF111111),
                    backgroundImage: _base64Image != null 
                        ? MemoryImage(base64Decode(_base64Image!))
                        : null,
                    child: _base64Image == null 
                        ? const Icon(Icons.person, size: 60, color: Color(0xFF00FF41))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00FF41),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _firstNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Ism',
                labelStyle: const TextStyle(color: Color(0xFF00FF41)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF008F11))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF41))),
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00FF41)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Familiya',
                labelStyle: const TextStyle(color: Color(0xFF00FF41)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF008F11))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF41))),
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00FF41)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Telefon raqam',
                labelStyle: const TextStyle(color: Color(0xFF00FF41)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF008F11))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00FF41))),
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF00FF41)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF41),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Saqlash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
            
            // Dasturchi bo'limi
            ListTile(
              onTap: () => Navigator.pushNamed(context, '/developer'),
              tileColor: const Color(0xFF111111),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.code, color: Color(0xFF00FF41)),
              title: const Text('Dasturchi haqida', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ),
            
            // Admin Panel
            if (isAdmin) ...[
              const SizedBox(height: 15),
              ListTile(
                onTap: () => Navigator.pushNamed(context, '/admin'),
                tileColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.red)),
                leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
                title: const Text('Admin Panel', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
