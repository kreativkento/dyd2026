import '../models/content_models.dart';
import 'parish_image_assets.dart';

/// Primary label for a parish row — [Parish.name] from [vicariates.json].
String parishAccordionPrimaryLabel(
  Parish parish,
  List<Parish> parishesInVicariate,
) {
  final name = parish.name.trim();
  final duplicates = parishesInVicariate
      .where((p) => p.name.trim() == name)
      .length;
  if (duplicates <= 1) return name;

  final place = parishAddressPlaceName(parish.address);
  if (place.isEmpty) return name;
  return '$name ($place)';
}

/// Place line under the parish name (hidden when place is in the title).
bool parishAccordionShowPlaceSubtitle(
  Parish parish,
  List<Parish> parishesInVicariate,
) {
  final name = parish.name.trim();
  final duplicates = parishesInVicariate
      .where((p) => p.name.trim() == name)
      .length;
  if (duplicates > 1) return false;
  return parish.address.trim().isNotEmpty;
}

/// Vicariate accordion title — exactly [Vicariate.name] from [vicariates.json].
String vicariateAccordionTitle(Vicariate vicariate) => vicariate.name.trim();
