const rosterAvatarAssets = <String>[
  'assets/images/avatars/img_avatar1.png',
  'assets/images/avatars/img_avatar2.png',
  'assets/images/avatars/img_avatar3.png',
  'assets/images/avatars/img_avatar4.png',
];

const _avatarByParish = <String, String>{
  'Allen': 'assets/images/avatars/img_avatar1.png',
  'Catarman': 'assets/images/avatars/img_avatar1.png',
  'Gamay': 'assets/images/avatars/img_avatar1.png',
  'Las Navas': 'assets/images/avatars/img_avatar1.png',
  'Mondragon': 'assets/images/avatars/img_avatar1.png',
  'San Antonio': 'assets/images/avatars/img_avatar1.png',
  'San Vicente': 'assets/images/avatars/img_avatar1.png',
  'Biri': 'assets/images/avatars/img_avatar2.png',
  'Catubig': 'assets/images/avatars/img_avatar2.png',
  'Hibubullao': 'assets/images/avatars/img_avatar2.png',
  'Lavezares': 'assets/images/avatars/img_avatar2.png',
  'Pambujan': 'assets/images/avatars/img_avatar2.png',
  'San Isidro': 'assets/images/avatars/img_avatar2.png',
  'Silvino Lobos': 'assets/images/avatars/img_avatar2.png',
  'Bobon': 'assets/images/avatars/img_avatar3.png',
  'Cawayan': 'assets/images/avatars/img_avatar3.png',
  'Laoang': 'assets/images/avatars/img_avatar3.png',
  'Lope De Vega': 'assets/images/avatars/img_avatar3.png',
  'Polangi': 'assets/images/avatars/img_avatar3.png',
  'San Jose': 'assets/images/avatars/img_avatar3.png',
  'Uep': 'assets/images/avatars/img_avatar3.png',
  'Capul': 'assets/images/avatars/img_avatar4.png',
  'Dalakit': 'assets/images/avatars/img_avatar4.png',
  'Lapinig': 'assets/images/avatars/img_avatar4.png',
  'Mapanas': 'assets/images/avatars/img_avatar4.png',
  'Rosario': 'assets/images/avatars/img_avatar4.png',
  'San Roque': 'assets/images/avatars/img_avatar4.png',
  'Victoria': 'assets/images/avatars/img_avatar4.png',
};

/// Parish → avatar mapping from event roster groupings.
String rosterAvatarAssetFor({
  required String fullName,
  required String group,
  required int index,
  required String parishMunicipality,
}) {
  return rosterAvatarAssetForParish(parishMunicipality);
}

String rosterAvatarAssetForParish(String parishMunicipality) {
  return _avatarByParish[parishMunicipality.trim()] ?? rosterAvatarAssets.first;
}
