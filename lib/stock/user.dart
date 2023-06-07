import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:sigest/models/user.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import '../api/response.dart';
import 'abstract_repository.dart';

@Named('user')
@LazySingleton(as: AbstractRepository)
class UserRepository extends HiveStock<UserModel> {
  @override
  String get name => 'user';

  UserModel get user => get('user') as UserModel;

  @override
  Future<UserModel> loadModel(String key) async {
    Response response = await api.user();

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;
    UserModel newUser = UserModel.fromJson(response.data);
    UserModel? user = get(newUser.id);

    if (user != null) {
      newUser.stat['last_level_passed'] = user.stat['last_level_passed'];
      newUser.stat['achieved_goal_updated'] =
          user.stat['achieved_goal_updated'];
    } else {
      final yesterday = DateTime.now().subtract(const Duration(days: 1)).toUtc();
      newUser.stat['last_level_passed'] = yesterday.toString();
      newUser.stat['achieved_goal_updated'] = yesterday.toString();
      UserModel user = UserModel(
          id: newUser.id,
          username: newUser.username,
          email: newUser.email,
          stat: newUser.stat);
      put(newUser.id, user);
    }

    return newUser;
  }

  bool lastLevelPassedTodayOrYesterday() {
    DateTime currentDate = DateTime.now();
    DateTime prevDate = DateTime.now().subtract(const Duration(days: 1));
    DateTime oldDate = DateTime.parse(user.stat['last_level_passed']).toLocal();

    return oldDate.year == currentDate.year &&
            oldDate.month == currentDate.month &&
            oldDate.day == currentDate.day ||
        oldDate.year == prevDate.year &&
            oldDate.month == prevDate.month &&
            oldDate.day == prevDate.day;
  }

  bool lastLevelPassedToday() {
    DateTime currentDate = DateTime.now();
    DateTime oldDate = DateTime.parse(user.stat['last_level_passed']).toLocal();

    return oldDate.year == currentDate.year &&
        oldDate.month == currentDate.month &&
        oldDate.day == currentDate.day;
  }

  bool achievedGoalUpdatedToday() {
    DateTime currentDate = DateTime.now();
    DateTime oldDate =
        DateTime.parse(user.stat['achieved_goal_updated']).toLocal();

    return oldDate.year == currentDate.year &&
        oldDate.month == currentDate.month &&
        oldDate.day == currentDate.day;
  }

  Future<void> checkAndUpdateStats() async {
    bool updateImpactMode = true;
    bool updateAchievedGoal = true;
    DateTime oldDate = DateTime.parse(user.stat['last_level_passed']).toLocal();

    if (lastLevelPassedTodayOrYesterday()) {
      updateImpactMode = false;
    }

    if (achievedGoalUpdatedToday()) {
      updateAchievedGoal = false;
    }

    if (updateImpactMode || updateAchievedGoal) {
      UserModel user = this.user;
      user.stat['impact_mode'] =
          updateImpactMode ? 0 : user.stat['impact_mode'];
      user.stat['goal_achieved'] =
          updateAchievedGoal ? 0 : user.stat['goal_achieved'];
      user.stat['achieved_goal_updated'] = updateAchievedGoal
          ? DateTime.now().toUtc().toString()
          : user.stat['achieved_goal_updated'];
      user.save();

      UserModel? curUser = get(user.id);
      curUser?.stat['impact_mode'] = user.stat['impact_mode'];
      curUser?.stat['goal_achieved'] = user.stat['goal_achieved'];
      curUser?.stat['achieved_goal_updated'] =
          user.stat['achieved_goal_updated'];
      curUser?.save();

      await api.updateStats(Params({}, {
        "impact_mode": user.stat['impact_mode'],
        "goal_achieved": user.stat['goal_achieved']
      }));
    }
  }

  @override
  void clear() {
    store.delete(user.id);
    store.delete('user');
  }

  Future<Response> deleteUser() async {
    Response response = await api.deleteUser();

    return response;
  }

  Future<Response> updateUser(Params userParams) async {
    Response response = await api.updateUser(userParams);

    if (response is SuccessResponse) {
      UserModel user = this.user;
      user.email = response.data['email'];
      user.username = response.data['username'];
      user.save();
    }

    return response;
  }

  Future<void> updateStats(Map<String, dynamic> newStat) async {
    UserModel? user = this.user;
    user.stat = newStat;
    user.save();

    user = get(user.id);
    user?.stat = newStat;
    user?.save();

    await api.updateStats(Params({}, newStat));
  }
}
