// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import file utama dan sembunyikan nama yang berpotensi konflik
// Pastikan path ke main_viewmodel menggunakan 'UI' (huruf besar) sesuai struktur folder Anda
import 'package:mopro_tugas/main.dart' hide MainViewModel, GigFinderApp; 
import 'package:mopro_tugas/main.dart' as app; // Gunakan prefix jika ingin memanggil kelas dari main
import 'package:mopro_tugas/UI/viewmodels/main_viewmodel.dart'; 

void main() {
  testWidgets('GigFinder App smoke test', (WidgetTester tester) async {
    // Bangun aplikasi di dalam lingkungan test
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => MainViewModel(),
        child: const app.GigFinderApp(), // Gunakan prefix 'app.' untuk merujuk ke class di main.dart
      ),
    );

    // Karena InitialAuthScreen sekarang adalah gerbang pertama, 
    // kita harus melewati login terlebih dahulu agar bisa melihat 'Konser Unggulan'
    
    // 1. Verifikasi kita berada di InitialAuthScreen
    expect(find.text('Masuk sebagai Pengunjung'), findsOneWidget);

    // 2. Simulasi tap untuk masuk ke aplikasi utama
    await tester.tap(find.text('Masuk sebagai Pengunjung'));
    await tester.pumpAndSettle(); // Tunggu transisi ke HomeScreen

    // 3. Verifikasi teks di HomeScreen muncul
    expect(find.text('Konser Unggulan 🔥'), findsOneWidget);

    // 4. Verifikasi Bottom Navigation Bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // 5. Navigasi ke menu News
    await tester.tap(find.byIcon(Icons.article));
    await tester.pumpAndSettle();

    // 6. Verifikasi AppBar di NewsScreen
    expect(find.text('Berita Band & Gig'), findsOneWidget);
  });
}