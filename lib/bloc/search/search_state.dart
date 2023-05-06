part of 'search_cubit.dart';

@immutable
abstract class SearchState extends MainState {}

class Searching extends SearchState {}

class Searched extends SearchState {}