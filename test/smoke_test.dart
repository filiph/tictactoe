import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/main.dart';
import 'package:tictactoe/src/player_progress/persistence/memory_player_progress_persistence.dart';
import 'package:tictactoe/src/settings/persistence/memory_settings_persistence.dart';

void main() {
  testWidgets('smoke test', (tester) async {
    // Build our game and trigger a frame.
    await tester.pumpWidget(MyApp(
      settingsPersistence: MemoryOnlySettingsPersistence(),
      playerProgressPersistence: MemoryOnlyPlayerProgressPersistence(),
      adsController: null,
      gamesServicesController: null,
      inAppPurchaseController: null,
    ));

    // Verify that the 'Play' button is shown.
    expect(find.text('Play'), findsOneWidget);

    // Verify that the 'Settings' button is shown.
    expect(find.text('Settings'), findsOneWidget);

    // Go to 'Settings'.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);

    // Go back to main menu.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Tap 'Play'.
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.text('Select level'), findsOneWidget);

    // Tap level 1.
    await tester.tap(find.bySemanticsLabel('Level 1'));
    await tester.pumpAndSettle();
    expect(find.text('Restart'), findsOneWidget);
  });
}
