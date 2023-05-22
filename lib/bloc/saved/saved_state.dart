part of 'saved_cubit.dart';

@immutable
abstract class SavedState extends MainState {}

class Searching extends SavedState {}

class Searched extends SavedState {}

class Deleting extends SavedState {}

class Deleted extends SavedState {}

class NotDeleted extends SavedState {}
