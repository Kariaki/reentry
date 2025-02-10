import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/exception/app_exceptions.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';

class GoalRepository {
  Future<Stream<List<GoalDto>>> fetchActiveGoals({String? userId}) async {
    final collection = await _getGoalCollection(userId: userId);
    return collection
        .orderBy(GoalDto.keyCreatedAt, descending: true)
        .snapshots()
        .map((element) {
      return element.docs.map((e) => GoalDto.fromJson(e.data())).toList();
    });
  }

  Future<List<GoalDto>> fetchAllUserGoals(String userId) async {
    final collection = await _getGoalCollection(userId: userId);
    final result = await collection.get();
    return result.docs.map((e) => GoalDto.fromJson(e.data())).toList();
  }

  Future<Stream<List<GoalDto>>> fetchGoalHistory() async {
    final collection = await _getGoalCollection();
    return collection
        .where(
          GoalDto.keyProgress,
          isEqualTo: 100,
        )
        .orderBy(GoalDto.keyCreatedAt, descending: true)
        .snapshots()
        .map((element) {
      return element.docs.map((e) => GoalDto.fromJson(e.data())).toList();
    });
  }
  Future<Stream<List<GoalDto>>> fetchAllGoals() async {
    final collection = await _getGoalCollection();
    return collection
        .where(
          GoalDto.keyProgress,
          isEqualTo: 100,
        )
        .orderBy(GoalDto.keyCreatedAt, descending: true)
        .snapshots()
        .map((element) {
      return element.docs.map((e) => GoalDto.fromJson(e.data())).toList();
    });
  }

  final collection = FirebaseFirestore.instance.collection('user');

  Future<GoalDto> createGoal(CreateGoalEvent event) async {
    final currentUser = await PersistentStorage.getCurrentUser();
    if (currentUser == null) {
      throw BaseExceptions('User not found');
    }
    final goalsCollection = await _getGoalCollection();
    final doc = goalsCollection.doc();
    var copyWith =
        event.toGoalDto().copyWith(id: doc.id, userId: currentUser.userId);
    await doc.set(copyWith.toJson());
    return copyWith;
  }

  Future<CollectionReference<Map<String, dynamic>>> _getGoalCollection(
      {String? userId}) async {
    // final currentUser = await PersistentStorage.getCurrentUser();
    final userIdentifier =
        userId ?? (await PersistentStorage.getCurrentUser())?.userId;
    if (userIdentifier == null) {
      throw BaseExceptions('User not found');
    }
    final userDoc = collection.doc(userIdentifier);
    final userGoalsCollection = userDoc.collection('goals');
    return userGoalsCollection;
  }

  Future<void> deleteGoals(String goalId) async {
    final collection = await _getGoalCollection();
    await collection.doc(goalId).delete();
  }

  Future<void> updateGoal(GoalDto event) async {
    final collection = await _getGoalCollection();
    final doc = collection.doc(event.id);
    await doc.set(event.toJson());
  }
}
