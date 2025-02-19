import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/data/shared/share_preference.dart';
import 'package:reentry/exception/app_exceptions.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';

class ActivityRepository {
  Future<Stream<List<ActivityDto>>> fetchActiveActivities(
      {String? userId}) async {
    final collection = await _getActivityCollection(userId: userId);
    return collection
        .where(
          GoalDto.keyProgress,
          isLessThan: 100,
        )
        .where("endDate", isGreaterThan: DateTime.now().millisecondsSinceEpoch)
        .snapshots()
        .map((element) {
      return element.docs.map((e) => ActivityDto.fromJson(e.data())).toList();
    });
  }

  Future<List<ActivityDto>> fetchAllUsersActivity(String userId) async {
    final collection = await _getActivityCollection(userId: userId);
    final result = await collection.get();
    return result.docs.map((e) => ActivityDto.fromJson(e.data())).toList();
  }

  Future<Stream<List<ActivityDto>>> fetchAllUsersActivityStream( {String? userId}) async {
    final collection = await _getActivityCollection(userId: userId);
    return collection

        .snapshots()
        .map((element) {
      return element.docs.map((e) => ActivityDto.fromJson(e.data())).toList().reversed.toList();
    });
  }

  Future<Stream<List<ActivityDto>>> fetchActivityHistory() async {
    final collection = await _getActivityCollection();
    return collection
        .where("endDate", isLessThan: DateTime.now().millisecondsSinceEpoch)
        .orderBy(GoalDto.keyCreatedAt, descending: true)
        .snapshots()
        .map((element) {
      return element.docs.map((e) => ActivityDto.fromJson(e.data())).toList();
    });
  }

  final collection = FirebaseFirestore.instance.collection('user');

  Future<ActivityDto> createActivity(CreateActivityEvent event) async {
    final currentUser = await PersistentStorage.getCurrentUser();
    if (currentUser == null) {
      throw BaseExceptions('User not found');
    }
    final activityCollection = await _getActivityCollection();
    final doc = activityCollection.doc();
    var copyWith = event.toActivityDto().copyWith(id: doc.id);
    await doc.set(copyWith.toJson());
    return copyWith;
  }

  Future<CollectionReference<Map<String, dynamic>>> _getActivityCollection(
      {String? userId}) async {
    // final currentUser = await PersistentStorage.getCurrentUser();
    final userIdentifier =
        userId ?? (await PersistentStorage.getCurrentUser())?.userId;
    if (userIdentifier == null) {
      print('******************* user not found');
      throw BaseExceptions('User not found');
    }
    final userDoc = collection.doc(userIdentifier);
    final userGoalsCollection = userDoc.collection('activities');
    return userGoalsCollection;
  }

  Future<void> deleteActivity(String goalId) async {
    final collection = await _getActivityCollection();
    await collection.doc(goalId).delete();
  }

  Future<void> updateActivity(ActivityDto event) async {
    final collection = await _getActivityCollection();
    final doc = collection.doc(event.id);
    await doc.set(event.toJson());
  }
}
