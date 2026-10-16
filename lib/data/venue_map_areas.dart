/// Venue map dropdown areas and image assets under [assets/images/venue/].
///
/// Set [staticAsset] for a single map image, or [carouselAssets] / [stackedAssets]
/// for multi-image areas.
class VenueMapArea {
  const VenueMapArea({
    required this.id,
    required this.label,
    this.carouselAssets,
    this.carouselAspectRatio,
    this.stackedAssets,
    this.staticAsset,
  });

  final String id;
  final String label;
  final List<String>? carouselAssets;
  /// When set, used for [FadeAssetCarousel] instead of the default 4:3 frame.
  final double? carouselAspectRatio;
  final List<String>? stackedAssets;
  final String? staticAsset;

  String get imageAsset => 'assets/images/venue/$id/map.png';

  String get displayImageAsset =>
      (staticAsset != null && staticAsset!.trim().isNotEmpty)
          ? staticAsset!.trim()
          : imageAsset;

  bool get usesCarousel =>
      carouselAssets != null && carouselAssets!.isNotEmpty;

  bool get usesStackedGallery =>
      stackedAssets != null && stackedAssets!.isNotEmpty;
}

abstract final class VenueMapStaticAssets {
  static const whole = 'assets/images/venue/venue_whole.png';
  static const plenary = 'assets/images/venue/venue_plenary.png';
  static const stage = 'assets/images/venue/venue_stage.png';
  static const techMed = 'assets/images/venue/venue_tech_med.png';
  static const gate = 'assets/images/venue/venue_gate.png';
  static const regFood = 'assets/images/venue/venue_reg_food.png';
  static const merch = 'assets/images/venue/venue_merch.png';
  static const committee = 'assets/images/venue/venue_committee.png';

  static const parkingStack = [
    'assets/images/venue/venue_park_1.png',
    'assets/images/venue/venue_park_2.png',
    'assets/images/venue/venue_park_3.png',
    'assets/images/venue/parking_area/venue_parking_4.png',
  ];

  static const restroomsStack = [
    'assets/images/venue/cr_1.png',
    'assets/images/venue/cr_2.png',
    'assets/images/venue/cr_3.png',
    'assets/images/venue/cr_4.png',
  ];
}

const venueMapAreas = <VenueMapArea>[
  VenueMapArea(
    id: 'whole_venue',
    label: 'Whole Venue',
    staticAsset: VenueMapStaticAssets.whole,
  ),
  VenueMapArea(
    id: 'plenary_hall',
    label: 'Plenary Hall',
    staticAsset: VenueMapStaticAssets.plenary,
  ),
  VenueMapArea(
    id: 'main_stage',
    label: 'Main Stage',
    staticAsset: VenueMapStaticAssets.stage,
  ),
  VenueMapArea(
    id: 'technical_booth',
    label: 'Technical Booth',
    staticAsset: VenueMapStaticAssets.techMed,
  ),
  VenueMapArea(
    id: 'gate',
    label: 'Entrance / Exit',
    staticAsset: VenueMapStaticAssets.gate,
  ),
  VenueMapArea(
    id: 'registration_area',
    label: 'Registration Area',
    staticAsset: VenueMapStaticAssets.regFood,
  ),
  VenueMapArea(
    id: 'medical_station',
    label: 'Medical Station',
    staticAsset: VenueMapStaticAssets.techMed,
  ),
  VenueMapArea(
    id: 'food_station',
    label: 'Food Station',
    staticAsset: VenueMapStaticAssets.regFood,
  ),
  VenueMapArea(
    id: 'restrooms',
    label: 'Restrooms',
    stackedAssets: VenueMapStaticAssets.restroomsStack,
  ),
  VenueMapArea(
    id: 'merch_area',
    label: 'Merch Area',
    staticAsset: VenueMapStaticAssets.merch,
  ),
  VenueMapArea(
    id: 'parking_area',
    label: 'Parking Area',
    stackedAssets: VenueMapStaticAssets.parkingStack,
  ),
  VenueMapArea(
    id: 'committee_area',
    label: 'Committee Area',
    staticAsset: VenueMapStaticAssets.committee,
  ),
];

/// Venue map dropdown entries sorted A–Z by [VenueMapArea.label].
final List<VenueMapArea> venueMapAreasAlphabetical = List<VenueMapArea>.from(
  venueMapAreas,
)..sort((a, b) => a.label.compareTo(b.label));

VenueMapArea venueMapAreaById(String id) =>
    venueMapAreas.firstWhere((area) => area.id == id);
