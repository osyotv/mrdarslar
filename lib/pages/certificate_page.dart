import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  String userName = "O'quvchi";
  String userId = "00000";
  final ScreenshotController screenshotController = ScreenshotController();
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String fn = prefs.getString('first_name') ?? "O'quvchi";
    String ln = prefs.getString('last_name') ?? "";
    int uid = prefs.getInt('user_id') ?? 0;
    setState(() {
      userName = "$fn $ln".trim();
      userId = uid.toString();
    });
  }

  Future<void> _shareCertificate() async {
    setState(() {
      isCapturing = true;
    });

    try {
      final image = await screenshotController.capture(delay: const Duration(milliseconds: 10));
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/MR_Sertifikat.png').create();
        await imagePath.writeAsBytes(image);

        // Share using share_plus
        await Share.shareXFiles([XFile(imagePath.path)], text: 'Men Python darslarini muvaffaqiyatli tugatdim! 🎉');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Xatolik: $e')));
      }
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sertifikat')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 350,
                  height: 250,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09090B),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFFFD700), width: 3), // Golden border
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.3), blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 40),
                          SizedBox(width: 10),
                          Text("SERTIFIKAT", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFFD700), letterSpacing: 2)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text("Ushbu sertifikat tasdiqlaydiki,", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 5),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Courier'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Python dasturlash tili bo'yicha 10 ta darsni va testlarni mukammal darajada yakunladi.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sana: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}", style: const TextStyle(color: Colors.white54, fontSize: 10)),
                              Text("ID: $userId", style: const TextStyle(color: Colors.white54, fontSize: 10)),
                              const SizedBox(height: 5),
                              const Text("MR Darslari / Kiberxavfsizlik", style: TextStyle(color: Color(0xFF00FF41), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            color: Colors.white,
                            child: QrImageView(
                              data: "MR Darslari - Python. ID: $userId, Ism: $userName",
                              version: QrVersions.auto,
                              size: 50.0,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              isCapturing
                  ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                  : ElevatedButton.icon(
                      onPressed: _shareCertificate,
                      icon: const Icon(Icons.share, color: Colors.black),
                      label: const Text("Sertifikatni Ulashish / Saqlash", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
