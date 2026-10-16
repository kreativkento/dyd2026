import '../models/content_models.dart';

/// Fallback schedule when [EventContent.schedule] lacks Part I/II markers.
/// Keep in sync with [assets/data/event.json] `schedule`.
List<ScheduleItem> officialEventSchedule() {
  return const [
    ScheduleItem(
      time: '8:00–10:00 AM',
      title: 'Arrival, Registration & Preliminaries',
      part: 'Part I — Encounter',
      description:
          '• Getting to Know Our Kalakbay\n• Animation\n• Host Interview',
    ),
    ScheduleItem(
      time: '10:00–10:30 AM',
      title: 'Rosary',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '10:30–11:00 AM',
      title:
          'Enthronement of the Image of St. Pedro Calungsod,\nThe Miraculous Salus Populi Romani,\nand Diocese of Catarman Youth Cross',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '11:00 AM–12:30 PM',
      title: 'Eucharistic Celebration',
      part: 'Part I — Encounter',
      description: '• MOST. REV. NOLLY C. BUCO, DD',
    ),
    ScheduleItem(
      time: '12:30–12:45 PM',
      title: 'Orientation | General Rules',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '12:45–1:30 PM',
      title: 'Lunch',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '1:30–2:30 PM',
      title: 'Welcome Proper',
      part: 'Part I — Encounter',
      description: '• National Anthem\n• Animation',
    ),
    ScheduleItem(
      time: '2:30–3:00 PM',
      title: 'Welcome Remarks',
      part: 'Part I — Encounter',
      description: '• DYL Ms. Jessa Mae S. Arcipe, LPT',
    ),
    ScheduleItem(
      time: '3:00–3:30 PM',
      title: 'Animation\nGame for Groupings\nIntroduction to the Speaker',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '3:30–4:30 PM',
      title: 'Talk',
      part: 'Part I — Encounter',
      description: '• Jefrey N. Tungol, MA, RGC, RPm, CPS, PSF',
    ),
    ScheduleItem(
      time: '4:30–5:30 PM',
      title: 'Processing',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '5:30–6:00 PM',
      title: 'Pilgrim Walk & Novena',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '6:00–7:30 PM',
      title: 'Dinner / Rest',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '7:30–8:00 PM',
      title: 'Animation / GTKK',
      part: 'Part II — Mission',
    ),
    ScheduleItem(
      time: '8:00–9:30 PM',
      title: 'KaKwentuhan',
      part: 'Part II — Mission',
      description: '• Testimonies / Performance',
    ),
    ScheduleItem(
      time: '9:30–11:00 PM',
      title: 'Vigil',
      part: 'Part II — Mission',
      description:
          '• Liturgy of the Word\n• Sharing\n• Gospel\n• Eucharistic Adoration',
    ),
    ScheduleItem(
      time: '11:00 PM–12 MN',
      title: 'Eucharistic Celebration (for Sunday)',
      part: 'Part II — Mission',
      description:
          '• Commissioning Ceremony for the Diocese Youth Council Officers\n• Turn Over',
    ),
    ScheduleItem(
      time: '12 MN Onwards',
      title: 'Giving of Certificates',
      part: 'Part II — Mission',
      description: '• Liturgy of the Word\n• Home Sweet Home',
    ),
  ];
}

List<ScheduleItem> scheduleForPart(
  List<ScheduleItem> schedule,
  ScheduleProgramPart part,
) {
  return schedule.where((item) => item.schedulePart == part).toList();
}
