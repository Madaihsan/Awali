import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'services/pin_service.dart';
import 'services/secure_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWALI - Presensi Pegawai',
      theme: AppTheme.light,
      home: const MyHomePage(title: 'AWALI - Presensi Pegawai (M01)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _storageStatus = 'Menginisialisasi Secure Storage...';

  @override
  void initState() {
    super.initState();
    _writeSecureData();
  }

  Future<void> _writeSecureData() async {
    try {
      // Inisialisasi data terenkripsi untuk bukti SEC-01 & SEC-02
      await PinService().setPin('1234');
      await SecureStorageService().saveUserSession(
        '2300016158',
        'secure_token_session_hash',
      );
      if (mounted) {
        setState(() {
          _storageStatus =
              'Data terenkripsi berhasil disimpan ke Android Keystore (SEC-01)';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _storageStatus = 'Status penyimpanan: $e';
        });
      }
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _writeSecureData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Status Keamanan M01:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _storageStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              const Text('Jumlah ketukan uji:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Uji Simpan Kredensial',
        child: const Icon(Icons.add),
      ),
    );
  }
}
