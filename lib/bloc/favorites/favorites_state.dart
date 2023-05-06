part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState extends MainState {}

class Searching extends FavoritesState {}

class Searched extends FavoritesState {}
