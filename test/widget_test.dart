import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import file utama dan VM Anda
import 'package:mopro_tugas/main.dart';
import 'package:mopro_tugas/ui/viewmodels/main_viewmodel.dart';

void main() {
  testWidgets('GigFinder App smoke test', (WidgetTester tester) async {
    // Bangun aplikasi di dalam lingkungan test
    // Karena aplikasi menggunakan Provider, kita harus membungkusnya agar tidak error
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => MainViewModel())],
        child: const GigFinderApp(),
      ),
    );

    // 1. Verifikasi bahwa judul aplikasi atau teks utama muncul
    // Kita mencari teks 'Konser Unggulan' yang ada di HomeScreen
    expect(find.text('Konser Unggulan 🔥'), findsOneWidget);

    // 2. Verifikasi keberadaan Bottom Navigation Bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // 3. Verifikasi keberadaan ikon navigasi
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.article), findsOneWidget); // Menu News

    // 4. Simulasi interaksi: Tap pada menu News
    await tester.tap(find.byIcon(Icons.article));
    await tester.pumpAndSettle(); // Tunggu animasi transisi selesai

    // Verifikasi apakah AppBar di NewsScreen muncul
    expect(find.text('Berita Band & Gig'), findsOneWidget);
  });
}
