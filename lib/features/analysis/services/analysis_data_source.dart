import '../model/analysis_dto.dart';

abstract class AnalysisDataSource {
  Stream<List<AnalysisEntry>> watchAnalyses(String userId);

  Future<String> create(String userId, AnalysisDto analysis);
}
