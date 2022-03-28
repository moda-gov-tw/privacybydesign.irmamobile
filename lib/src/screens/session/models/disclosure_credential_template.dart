import 'package:collection/collection.dart';
import 'package:quiver/iterables.dart';

import '../../../models/attributes.dart';
import '../../../models/credentials.dart';
import 'abstract_disclosure_credential.dart';
import 'disclosure_credential.dart';

/// Template of a DisclosureCredential that needs to be obtained first.
class DisclosureCredentialTemplate extends AbstractDisclosureCredential {
  /// List of DisclosureCredentials that match the template.
  final UnmodifiableListView<DisclosureCredential> presentMatching;

  /// List of DisclosureCredentials with the same credential type that are present, but do not match with the template.
  final UnmodifiableListView<DisclosureCredential> presentNonMatching;

  factory DisclosureCredentialTemplate({
    required List<Attribute> attributes,
    required Iterable<Credential> credentials,
  }) =>
      DisclosureCredentialTemplate._(attributes: attributes).refresh(credentials);

  DisclosureCredentialTemplate._({
    required List<Attribute> attributes,
    List<DisclosureCredential> presentMatching = const [],
    List<DisclosureCredential> presentNonMatching = const [],
  })  : presentMatching = UnmodifiableListView(presentMatching),
        presentNonMatching = UnmodifiableListView(presentNonMatching),
        super(attributes: attributes);

  /// Indicates whether a credential is present that matches the template.
  bool get obtained => presentMatching.isNotEmpty;

  // TODO: Why is this executed so often?
  /// Returns a new credential template with presentMatching and presentNonMatching being refreshed using the given credentials.
  DisclosureCredentialTemplate refresh(Iterable<Credential> credentials) {
    final presentCreds = credentials.where((cred) => cred.info.fullId == fullId);
    return _refreshPresentCredentials(
      // Only include the attributes that are included in the template.
      presentCreds.map((cred) => DisclosureCredential(
          attributes: cred.attributeList
              .where((attr1) => attributes.any((attr2) => attr1.attributeType.fullId == attr2.attributeType.fullId))
              .toList())),
    );
  }

  DisclosureCredentialTemplate _refreshPresentCredentials(Iterable<DisclosureCredential> presentCredentials) {
    final Map<bool, List<DisclosureCredential>> mapped = groupBy(
        presentCredentials,
        // Group based on whether the credentials match the template or not.
        // The attribute lists have an equal length and order due to the filtering above and guarantees from irmago.
        (cred) => zip([attributes, cred.attributes])
            .every((entry) => entry[0].value.raw == null || entry[0].value.raw == entry[1].value.raw));
    return DisclosureCredentialTemplate._(
      attributes: attributes,
      presentMatching: mapped[true] ?? [],
      presentNonMatching: mapped[false] ?? [],
    );
  }

  /// Merges this template with the given other template if they don't contradict, and returns null otherwise.
  DisclosureCredentialTemplate? merge(DisclosureCredentialTemplate other) {
    if (fullId != other.fullId) return null;

    // If a attribute type must have multiple values, then the instances cannot be merged.
    final attributesMap = [...attributes, ...other.attributes].groupSetsBy((attr) => attr.attributeType.fullId);
    final List<Attribute> mergedAttributes = [];
    for (final attrSet in attributesMap.values) {
      final attr = attrSet.where((attr) => attr.value.raw != null);
      if (attr.length > 1) {
        return null;
      } else if (attr.length == 1) {
        mergedAttributes.add(attr.first);
      } else {
        // There are no specific values requested, so we can simply show the first one.
        mergedAttributes.add(attrSet.first);
      }
    }
    final creds = [...presentMatching, ...presentNonMatching];
    final otherCreds = [...other.presentMatching, ...other.presentNonMatching];
    return DisclosureCredentialTemplate._(attributes: mergedAttributes)._refreshPresentCredentials(creds.map((cred) {
      final otherCred = otherCreds.firstWhere((cred2) => cred.credentialHash == cred2.credentialHash);
      return DisclosureCredential(
        // DisclosureCredentials don't contain all attributes, but only the attributes involved in the template.
        // Therefore, we have to check the present credentials from both this and the other template to find a
        // particular attribute.
        attributes: mergedAttributes
            .map((attr1) => [...cred.attributes, ...otherCred.attributes]
                .firstWhere((attr2) => attr1.attributeType.fullId == attr2.attributeType.fullId))
            .toList(),
      );
    }));
  }
}
