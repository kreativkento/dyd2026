import '../models/content_models.dart';

const parishImagesRoot = 'assets/images/parishes/';

/// Parish photos keyed by [Parish.id] when the address place name does not match the PNG.
const parishImageAssetByParishId = <String, String>{
  'miraculous-medal-uep': '${parishImagesRoot}UEP.png',
  'st-isidore-silvino-lobos': '${parishImagesRoot}SILVINO LOBOS.png',
  'nazareno-st-rock-cawayan': '${parishImagesRoot}CAWAYAN.png',
  'omph-dalakit': '${parishImagesRoot}DALAKIT.png',
  'st-joseph-polangi': '${parishImagesRoot}POLANGI.png',
  'st-anthony-padua-rawis': '${parishImagesRoot}RAWIS.png',
  'our-lady-salvation-salvacion': '${parishImagesRoot}SALVACION.png',
  'holy-family-hibubullao': '${parishImagesRoot}HIBUBULLAO.png',
};

/// Place name shown in lists: text before the first comma in [address].
String parishAddressPlaceName(String address) {
  final trimmed = address.trim();
  if (trimmed.isEmpty) return '';
  final comma = trimmed.indexOf(',');
  if (comma == -1) return trimmed;
  return trimmed.substring(0, comma).trim();
}

/// PNG file name in `assets/images/parishes/` (e.g. `Catarman` → `CATARMAN.png`).
String parishImageFileNameFromPlaceName(String placeName) {
  if (placeName.trim().isEmpty) return '';
  return '${placeName.trim().toUpperCase()}.png';
}

String parishImageAssetPathFromAddress(String address) {
  final place = parishAddressPlaceName(address);
  if (place.isEmpty) return '';
  final fileName = parishImageFileNameFromPlaceName(place);
  if (fileName.isEmpty) return '';
  return '$parishImagesRoot$fileName';
}

/// Preferred parish photo for directory modals (place name → PNG in [parishImagesRoot]).
String? parishProfileImageAsset(Parish parish) {
  final byId = parishImageAssetByParishId[parish.id];
  if (byId != null && byId.isNotEmpty) return byId;
  final fromAddress = parishImageAssetPathFromAddress(parish.address);
  if (fromAddress.isNotEmpty) return fromAddress;
  final legacy = parish.imageAsset?.trim();
  if (legacy != null && legacy.isNotEmpty) return legacy;
  return null;
}
