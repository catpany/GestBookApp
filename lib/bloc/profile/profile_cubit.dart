import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:sigest/bloc/main_cubit.dart';

import '../../models/user.dart';
import '../../stock/user.dart';

part 'profile_state.dart';

class ProfileCubit extends MainCubit {
  ProfileCubit() : super();

  @override
  List<String> get preloadStores => ['user'];
}
