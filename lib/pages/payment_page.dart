import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? paymentDay;

  @override
  void initState() {
    super.initState();
    _loadPaymentDay();
  }

  Future<void> _loadPaymentDay() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      paymentDay = prefs.getInt('payment_day');
    });
  }

  Future<void> _setPaymentDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('payment_day', day);
    setState(() {
      paymentDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To'lov Bo'limi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A2980), Color(0xFF26D0CE)]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("💳 Oylik To'lov Karta Raqami", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  SizedBox(height: 10),
                  Text("8600 0609 7374 6887", style: TextStyle(color: Colors.white, fontSize: 28, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("M R", style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            paymentDay != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 60),
                        const SizedBox(height: 10),
                        Text("Sizning oylik to'lov kuningiz har oyning $paymentDay-sanasida qilib belgilangan.", textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        const Text("Bu sanani endi o'zgartirib bo'lmaydi.", style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const Text("Oylik to'lov kuningizni tanlang (Masalan: oylik oladigan kuningiz)", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) {
                            showDialog(
                              context: context,
                              builder: (c) => AlertDialog(
                                backgroundColor: const Color(0xFF1E1E1E),
                                title: const Text("Tasdiqlash"),
                                content: Text("Har oyning ${picked.day}-kuni to'lov qilishingizni tasdiqlaysizmi?\n\nBu sanani keyin o'zgartirib bo'lmaydi."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c), child: const Text("Bekor qilish", style: TextStyle(color: Colors.white70))),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(c);
                                      _setPaymentDay(picked.day);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26D0CE), foregroundColor: Colors.black),
                                    child: const Text("Tasdiqlayman"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                        child: const Text("Sanani Tanlash", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
