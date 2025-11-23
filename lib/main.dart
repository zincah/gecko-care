import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/date_symbol_data_local.dart';   // ★ 추가
import 'package:intl/intl.dart';                     // ★ 추가

import 'common/db/app_database.dart';
import 'features/feeding/feeding_repo.dart';
import 'features/calendar/calendar_page.dart';
import 'features/animal/animal_list_page.dart'; // ✅ 새 화면 import

/// Drift DB Provider
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});

/// Feeding Repository Provider
final feedingRepoProvider = Provider<FeedingRepo>(
  (ref) => FeedingRepo(ref.read(dbProvider)),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 여기 두 줄이 핵심
  await initializeDateFormatting('ko_KR', null);
  Intl.defaultLocale = 'ko_KR';

  runApp(
    const ProviderScope(
      child: GeckoApp(),
    ),
  );
}

class GeckoApp extends StatelessWidget {
  const GeckoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Gecko Care',
      home: HomePage(),
    );
  }
}

/// 앱 첫 화면: 개체 관리 + 다이어리 버튼
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Gecko Care'),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton.filled(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: const Text(
                '개체 관리',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const AnimalListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: const Text(
                '다이어리',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const CalendarPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
