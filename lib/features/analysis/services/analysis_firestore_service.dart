import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/analysis_dto.dart';
import 'analysis_data_source.dart';

class AnalysisFirestoreService implements AnalysisDataSource {
  final FirebaseFirestore firestore;

  AnalysisFirestoreService(this.firestore);

  CollectionReference<Map<String, dynamic>> _analysesRef(String userId) {
    return firestore.collection('users').doc(userId).collection('analyses');
  }

  @override
  Stream<List<AnalysisEntry>> watchAnalyses(String userId) {
    return _analysesRef(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AnalysisEntry(
                  id: doc.id,
                  dto: AnalysisDto.fromMap(doc.data()),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<String> create(String userId, AnalysisDto analysis) async {
    final doc = await _analysesRef(userId).add(analysis.toMap());
    return doc.id;
  }
}
