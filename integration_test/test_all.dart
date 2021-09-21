// We cannot test using null safety as long as there are widgets that are not migrated yet.
// @dart=2.11

import 'enroll_test.dart' as enroll_test;
import 'issuance_test.dart' as issuance_test;
import 'login_test.dart' as login_test;
import 'screens_test.dart' as screens_test;

/// Wrapper to execute all tests at once.
void main() {
  screens_test.main();
  login_test.main();
  enroll_test.main();
  issuance_test.main();
}
