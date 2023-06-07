import 'dart:developer';

import 'package:meta/meta.dart';

import '../main_cubit.dart';

part 'units_state.dart';

class UnitsCubit extends MainCubit {
  UnitsCubit() : super();

  @override
  List<String> get preloadStores => ['units', 'user', 'lessons'];
}
