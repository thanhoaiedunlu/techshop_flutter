import 'package:flutter/material.dart';
import 'package:vietqr_flutter/vietqr_flutter.dart';

class Qr extends StatelessWidget {
  const Qr({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VietQR Demo',
      debugShowCheckedModeBanner: false, // Ẩn chữ "Debug"
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const QrPage(),
    );
  }
}

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  late final String qrCode;

  @override
  void initState() {
    super.initState();
    qrCode = _generateQr();
  }

  String _generateQr() {
    return VietQRGenerator.generate(
      accountNumber: '19038318210010',
      bankCode: '01310001',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VietQR'),
      ),
      body: Center(
        child: generatorQR(
          vietQr: qrCode,
          image: const AssetImage('assets/images/bank.png'),
          sizeQr: 300,
          sizeEmbeddingImage: 50,
        ),
      ),
    );
  }
}
