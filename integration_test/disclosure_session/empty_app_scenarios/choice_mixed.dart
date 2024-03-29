import 'package:flutter_test/flutter_test.dart';
import 'package:irmamobile/src/screens/add_data/add_data_details_screen.dart';
import 'package:irmamobile/src/screens/session/disclosure/widgets/disclosure_discon_stepper.dart';
import 'package:irmamobile/src/screens/session/disclosure/widgets/disclosure_permission_choice.dart';
import 'package:irmamobile/src/screens/session/disclosure/widgets/disclosure_permission_choices_screen.dart';
import 'package:irmamobile/src/widgets/credential_card/irma_credential_card.dart';
import 'package:irmamobile/src/widgets/irma_card.dart';

import '../../helpers/helpers.dart';
import '../../helpers/issuance_helpers.dart';
import '../../irma_binding.dart';
import '../../util.dart';
import '../disclosure_helpers.dart';

Future<void> choiceMixedTest(WidgetTester tester, IntegrationTestIrmaBinding irmaBinding) async {
  await pumpAndUnlockApp(tester, irmaBinding.repository);

  // Session requesting:
  // Address from multiplicity OR address from iDIN
  // AND your AGB code (from Nuts)
  const sessionRequest = '''
        {
          "@context": "https://irma.app/ld/request/disclosure/v2",
          "disclose": [
            [
              [ "irma-demo.gemeente.address.street", "irma-demo.gemeente.address.houseNumber", "irma-demo.gemeente.address.city" ],
              [ "irma-demo.idin.idin.address", "irma-demo.idin.idin.city"]
            ],
            [
              [ "irma-demo.nuts.agb.agbcode"]
            ]
          ]
        }
      ''';

  // Start session without the credential being present.
  await irmaBinding.repository.startTestSession(sessionRequest);
  await evaluateIntroduction(tester);

  // Expect a disclose stepper
  final disConStepperFinder = find.byType(DisclosureDisconStepper);
  expect(disConStepperFinder, findsOneWidget);

  // The discon stepper should have one choice
  final choiceFinder = find.descendant(
    of: disConStepperFinder,
    matching: find.byType(DisclosurePermissionChoice),
  );
  expect(choiceFinder, findsOneWidget);

  // The choice should consist of two cards
  final choiceCardsFinder = find.descendant(
    of: choiceFinder,
    matching: find.byType(IrmaCredentialCard),
  );
  expect(choiceCardsFinder, findsNWidgets(2));

  // First card in the choice should be selected
  await evaluateCredentialCard(
    tester,
    choiceCardsFinder.first,
    credentialName: 'Demo Address',
    issuerName: 'Demo Municipality',
    attributes: {},
    isSelected: true,
  );
  await evaluateCredentialCard(
    tester,
    choiceCardsFinder.at(1),
    credentialName: 'Demo iDIN',
    issuerName: 'Demo iDIN',
    attributes: {},
    isSelected: false,
  );

  // Select the iDIN option
  final iDinOptionFinder = find.text('Demo iDIN').first;
  await tester.ensureVisible(iDinOptionFinder);
  await tester.pumpAndSettle();
  await tester.tapAndSettle(iDinOptionFinder);

  // Now the second card in the choice should be highlighted, second card should be outlined
  await evaluateCredentialCard(
    tester,
    choiceCardsFinder.first,
    credentialName: 'Demo Address',
    issuerName: 'Demo Municipality',
    attributes: {},
    isSelected: false,
  );
  await evaluateCredentialCard(
    tester,
    choiceCardsFinder.at(1),
    credentialName: 'Demo iDIN',
    issuerName: 'Demo iDIN',
    attributes: {},
    isSelected: true,
  );

  // Continue and expect the AddDataDetailsScreen
  await tester.tapAndSettle(find.text('Obtain data'));
  expect(find.byType(AddDataDetailsScreen), findsOneWidget);
  await issueIdin(tester, irmaBinding);

  // The choice should have disappeared
  expect(choiceFinder, findsNothing);

  // Now the discon stepper should consist of two cards
  final disConCardsFinder = find.descendant(
    of: disConStepperFinder,
    matching: find.byType(IrmaCredentialCard),
  );
  expect(disConCardsFinder, findsNWidgets(2));

  // Now only the second discon card should be highlighted
  await evaluateCredentialCard(
    tester,
    disConCardsFinder.first,
    credentialName: 'Demo iDIN',
    issuerName: 'Demo iDIN',
    attributes: {},
    style: IrmaCardStyle.normal,
  );
  await evaluateCredentialCard(
    tester,
    disConCardsFinder.at(1),
    credentialName: 'Demo Vektis agb by Nuts',
    issuerName: 'Demo Nuts',
    attributes: {},
    style: IrmaCardStyle.highlighted,
  );

  // Continue and expect the AddDataDetailsScreen
  await tester.tapAndSettle(find.text('Obtain data'));
  expect(find.byType(AddDataDetailsScreen), findsOneWidget);

  // Obtain the data from Nuts
  await issueCredentials(tester, irmaBinding, {
    'irma-demo.nuts.agb.agbcode': '7722255556',
  });

  // Issue wizard should be completed
  expect(find.text('All required data has been added'), findsOneWidget);
  await tester.tapAndSettle(find.text('Next step'));

  // Expect the choices screen
  expect(find.byType(DisclosurePermissionChoicesScreen), findsOneWidget);
  await tester.tapAndSettle(find.text('Share data'));

  await evaluateShareDialog(tester);
  await evaluateFeedback(tester);
}
