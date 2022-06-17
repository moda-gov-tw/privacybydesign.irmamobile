bool pinSizeMustBeAtLeast5AtMost13(List<int> pin) {
  return pin.length >= 5 && pin.length <= 16;
}

// aaaaa ababa, every permutation of abbbb
bool pinMustContainAtLeastThreeUniqueNumbers(List<int> pin) {
  final counter = List.filled(10, 0, growable: false);
  for (final e in pin) {
    counter[e] = 1;
  }
  return 2 < counter.fold(0, (p, e) => p + e);
}

// abcba, abcab
// n = 5
bool pinMustNotContainPatternAbcba(List<int> pin) => !(pin[0] == pin[4] && pin[1] == pin[3]);
bool pinMustNotContainPatternAbcab(List<int> pin) => !(pin[0] == pin[3] && pin[1] == pin[4]);

/* forbidden series can be generalized as:
 * 1. asc
 * 2. desc
 * 3. asc  desc
 * 4. desc asc
 */
bool Function(List<int>) sequenceChecker(int delta) => (List<int> pin) {
      bool tracker = true;
      for (var i = 0; i < pin.length - 1 && tracker; i++) {
        tracker &= pin[i] + delta == pin[i + 1];
      }
      return tracker;
    };

bool pinMustNotBeMemberOfSeriesAscDesc(List<int> pin) {
  if (sequenceChecker(1)(pin) || sequenceChecker(-1)(pin)) {
    return false;
  }

  if (pin.length == 5) {
    final isAsc = sequenceChecker(1);
    final isDesc = sequenceChecker(-1);
    final firstSlice = pin.sublist(0, 3);
    final secondSlice = pin.sublist(2);

    if ((isAsc(firstSlice) && isDesc(secondSlice)) || (isDesc(firstSlice) && isAsc(secondSlice))) {
      return false;
    }
  }
  return true;
}

bool pinMustContainASublistOfSize5ThatCompliesToAllRules(List<int> pin) {
  if (!pinSizeMustBeAtLeast5AtMost13(pin)) {
    return false;
  }

  final rules = <bool Function(List<int>)>{
    pinMustContainAtLeastThreeUniqueNumbers,
    pinMustNotContainPatternAbcba,
    pinMustNotContainPatternAbcab,
    pinMustNotBeMemberOfSeriesAscDesc,
  };

  if (pin.length == 5) {
    return rules.every((r) => r(pin));
  } else {
    bool checker = false;
    for (int i = 0; i < pin.length - 5; i++) {
      final sub = pin.sublist(i, i + 5);
      checker |= rules.every((r) => r(sub));
    }
    return checker;
  }
}
