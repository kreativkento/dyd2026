import '../models/content_models.dart';

List<ScheduleItem> officialEventSchedule() {
  return const [
    ScheduleItem(
      time: '8:00–10:00 AM',
      title: 'Arrival, Registration & Preliminaries',
      part: 'Part I — Encounter',
      description: '• Getting to Know Our Kalakbay\n• Animation\n• Host Interview',
    ),
    ScheduleItem(
      time: '10:00–11:00 AM',
      title: 'Orientation | General Rules',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '11:00 AM–12:30 NN',
      title: 'Lunch',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '12:30 NN–1:00 PM',
      title: 'Rosary',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '1:00–2:30 PM',
      title: 'Eucharistic Celebration',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '2:30–3:00 PM',
      title: 'Rationale (DYL)',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '3:00–3:30 PM',
      title: 'Animation, Game for Groupings, Introduction to the Speaker',
      part: 'Part I — Encounter',
    ),
    ScheduleItem(
      time: '3:30–4:30 PM',
      title: 'Talk',
      part: 'Part I — Encounter',
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
      title: 'KaKwentuhan: Testimonies / Performance',
      part: 'Part II — Mission',
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
      title: 'Eucharistic Celebration (for Sunday) / Turn Over',
      part: 'Part II — Mission',
    ),
    ScheduleItem(
      time: '12 MN Onwards',
      title: 'Giving of Certificates / Photo Opportunity',
      part: 'Part II — Mission',
      description: 'Home Sweet Home',
    ),
  ];
}

List<ScheduleItem> scheduleForPart(
  List<ScheduleItem> schedule,
  ScheduleProgramPart part,
) {
  return schedule.where((item) => item.schedulePart == part).toList();
}
