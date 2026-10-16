import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/delegate_models.dart';

class DelegateService {
  DelegateService._();
  static final DelegateService instance = DelegateService._();

  List<DelegateEntry>? _delegates;

  Future<List<DelegateEntry>> get delegates async {
    _delegates ??= await _loadDelegates();
    return _delegates!;
  }

  Future<DelegateEntry?> findById(String id) async {
    final normalized = id.trim().toUpperCase();
    if (normalized.isEmpty) return null;

    final list = await delegates;
    for (final delegate in list) {
      if (delegate.id.trim().toUpperCase() == normalized) {
        return delegate;
      }
    }
    return null;
  }

  Future<List<DelegateEntry>> _loadDelegates() async {
    final raw = await rootBundle.loadString('assets/data/delegates.json');
    final decoded = json.decode(raw) as List;
    return decoded
        .map((entry) => DelegateEntry.fromJson(entry as Map<String, dynamic>))
        .toList();
  }
}
