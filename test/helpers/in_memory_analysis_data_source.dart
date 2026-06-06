import 'dart:async';

import 'package:mi_app/features/analysis/model/analysis_dto.dart';
import 'package:mi_app/features/analysis/services/analysis_data_source.dart';

class InMemoryAnalysisDataSource implements AnalysisDataSource {
  final _controller = StreamController<List<AnalysisEntry>>.broadcast();
  final Map<String, Map<String, AnalysisDto>> _store = {};

  @override
  Stream<List<AnalysisEntry>> watchAnalyses(String userId) async* {
    yield _entriesFor(userId);
    await for (final _ in _controller.stream) {
      yield _entriesFor(userId);
    }
  }

  List<AnalysisEntry> _entriesFor(String userId) {
    final items = _store[userId] ?? {};
    return items.entries
        .map((e) => AnalysisEntry(id: e.key, dto: e.value))
        .toList()
      ..sort((a, b) => b.dto.date.compareTo(a.dto.date));
  }

  void _emit(String userId) {
    if (!_controller.isClosed) {
      _controller.add(_entriesFor(userId));
    }
  }

  @override
  Future<String> create(String userId, AnalysisDto analysis) async {
    final id = 'analysis-${(_store[userId]?.length ?? 0) + 1}';
    _store.putIfAbsent(userId, () => {})[id] = analysis;
    _emit(userId);
    return id;
  }

  void dispose() {
    _controller.close();
  }
}
