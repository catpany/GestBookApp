part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState extends MainState {}

class Searching extends FavoritesState {}

class Searched extends FavoritesState {}

class Deleted extends FavoritesState {}

class Deleting extends FavoritesState {}

class NotDeleted extends FavoritesState {}
