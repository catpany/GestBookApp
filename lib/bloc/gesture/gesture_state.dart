part of 'gesture_cubit.dart';

@immutable
abstract class GestureState extends MainState {}

class Saved extends GestureState {}

class Saving extends GestureState {}

class NotSaved extends GestureState {}

class AddingToFavorites extends GestureState {}

class AddedToFavorites extends GestureState {}

class NotAddedToFavorites extends GestureState {}

class DeletingFromSaved extends GestureState {}

class DeletedFromSaved extends GestureState {}

class NotDeletedFromSaved extends GestureState {}

class DeletingFromFavorites extends GestureState {}

class DeletedFromFavorites extends GestureState {}

class NotDeletedFromFavorites extends GestureState {}