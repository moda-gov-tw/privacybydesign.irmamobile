// We cannot test using null safety as long as there are widgets that are not migrated yet.
// @dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:irmamobile/src/screens/activity/activity_tab.dart';
import 'package:irmamobile/src/screens/data/data_tab.dart';
import 'package:irmamobile/src/screens/home/home_tab.dart';
import 'package:irmamobile/src/screens/home/widgets/irma_nav_bar.dart';
import 'package:irmamobile/src/screens/more/more_tab.dart';
import 'package:irmamobile/src/screens/scanner/scanner_screen.dart';

import 'helpers.dart';
import 'irma_binding.dart';
import 'util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final irmaBinding = IntegrationTestIrmaBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('home', () {
    setUp(() => irmaBinding.setUp());
    tearDown(() => irmaBinding.tearDown());

    testWidgets('content', (tester) async {
      await pumpAndUnlockApp(tester, irmaBinding.repository);

      // Title
      expect(find.text('Your data,\non your phone.'), findsOneWidget);

      // Action cards
      expect(find.text('Get going'), findsOneWidget);
      final actionCardShareFinder = find.byKey(const Key('home_action_share'));
      expect(actionCardShareFinder, findsOneWidget);
      expect(
        find.descendant(
          of: actionCardShareFinder,
          matching: find.text('Share your data straight away'),
        ),
        findsOneWidget,
      );

      final actionCardFetchFinder = find.byKey(const Key('home_action_fetch'));
      expect(actionCardFetchFinder, findsOneWidget);
      expect(
        find.descendant(
          of: actionCardFetchFinder,
          matching: find.text('Fetch your data'),
        ),
        findsOneWidget,
      );

      // Recent activity
      expect(find.text('Recent activity'), findsOneWidget);
      expect(find.text('View more'), findsOneWidget);

      // More information
      expect(find.text('More information'), findsOneWidget);
      expect(find.byKey(const Key('home_info_safety')), findsOneWidget);
      expect(find.byKey(const Key('home_info_about')), findsOneWidget);
    });

    group('nav-bar', () {
      testWidgets('navigate-between-tabs', (tester) async {
        await pumpAndUnlockApp(tester, irmaBinding.repository);
        
        //Make sure hometab and nav bar are rendered
        expect(find.byType(IrmaNavBar), findsOneWidget);
        expect(find.byType(HomeTab), findsOneWidget);

        // Navigate to data
        await tester.tapAndSettle(find.byKey(const Key('nav_button_data')));
        expect(find.byType(HomeTab), findsNothing);
        expect(find.byType(DataTab), findsOneWidget);

        // Navigate to activity
        await tester.tapAndSettle(find.byKey(const Key('nav_button_activity')));
        expect(find.byType(DataTab), findsNothing);
        expect(find.byType(ActivityTab), findsOneWidget);

        //Navigate to more
        await tester.tapAndSettle(find.byKey(const Key('nav_button_more')));
        expect(find.byType(ActivityTab), findsNothing);
        expect(find.byType(MoreTab), findsOneWidget);

        //Navigate back to home
        await tester.tapAndSettle(find.byKey(const Key('nav_button_home')));
        expect(find.byType(MoreTab), findsNothing);
        expect(find.byType(HomeTab), findsOneWidget);
      }, timeout: const Timeout(Duration(seconds: 15)));

      testWidgets('open-scanner', (tester) async {
        await pumpAndUnlockApp(tester, irmaBinding.repository);
        //Make sure nav bar is rendered
        expect(find.byType(IrmaNavBar), findsOneWidget);

        // Tap open scanner button
        await tester.tapAndSettle(find.byKey(const Key('nav_button_scanner')));

        //Make sure scanner screen is open;
        expect(find.byType(ScannerScreen), findsOneWidget);
      }, timeout: const Timeout(Duration(seconds: 15)));
    });
  });
}
