import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/bloc/main_cubit.dart';

import '../../api/abstract_api.dart';
import '../../api/params.dart';
import '../../locator.dart';
import '../../models/gesture.dart';

part 'favorites_state.dart';

class FavoritesCubit extends MainCubit {
  @override
  List<String> get preloadStores => ['user', 'gestures', 'favorites'];
  List<GestureModel> searchResults = [];
  int page = 1;
  int total = 0;
  int perPage = 30;
  late AbstractApi api;

  FavoritesCubit() : super() {
    api = locator<AbstractApi>();
  }

  Future<void> search(String word, int pageKey) async {
    emit(Searching());

    searchResults = await store.favorites.search(store.user.user.id, word, pageKey);

    page = pageKey;
    total = searchResults.length;
    perPage = searchResults.length;

    emit(Searched());
  }

  Future<void> refresh() async {
    emit(Searching());

    searchResults = await store.favorites.refresh(store.user.user.id);

    page = store.favorites.page;
    total = store.favorites.total;
    perPage = store.favorites.perPage;

    emit(Searched());
  }

  bool isLastPage() {
    int totalPages = (total/perPage).ceil();
    totalPages = totalPages == 0 ? 1 : totalPages;

    return page == totalPages;
  }

  Future<void> getFavorites(int pageKey) async {
    emit(Searching());

    searchResults = await store.favorites.getFavorites(store.user.user.id, Params({}, {'page': pageKey}));
    page = store.favorites.page;
    total = store.favorites.total;
    perPage = store.favorites.perPage;

    emit(Searched());
  }

  Future<void> delete(GestureModel gesture) async {
    emit(Deleting());

    await store.favorites.deleteFromFavorites(store.user.user.id, gesture);

    bool deleted = await store.favorites.removeFromFavorites(
        store.user.user.id,
        gesture);

    deleted ? emit(Deleted()) : emit(NotDeleted());
  }
}
