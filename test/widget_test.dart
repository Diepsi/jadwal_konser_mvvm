// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import main.dart dengan prefix
import 'package:mopro_tugas/main.dart' as app;

// Import ViewModel
import 'package:mopro_tugas/UI/viewmodels/main_viewmodel.dart';

void main() {
  testWidgets(
    'ScientistFest App smoke test',
    (WidgetTester tester) async {
      // Build aplikasi
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => MainViewModel(),
          child: const app.ScientistFestApp(),
        ),
      );

      // Biarkan frame awal dirender
      await tester.pumpAndSettle();

      // 1. Verifikasi InitialAuthScreen muncul
      expect(find.text('Masuk sebagai Pengunjung'), findsOneWidget);

      // 2. Tap tombol masuk sebagai pengunjung
      await tester.tap(find.text('Masuk sebagai Pengunjung'));
      await tester.pumpAndSettle();

      // 3. Verifikasi HomeScreen tampil
      expect(find.text('Konser Unggulan 🔥'), findsOneWidget);

      // 4. Verifikasi BottomNavigationBar ada
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // 5. Navigasi ke tab News
      await tester.tap(find.byIcon(Icons.article));
      await tester.pumpAndSettle();

      // 6. Verifikasi AppBar di NewsScreen
      expect(find.text('Berita Band & Gig'), findsOneWidget);
    },
  );
}
