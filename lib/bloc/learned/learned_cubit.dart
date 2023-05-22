import 'package:meta/meta.dart';

import '../../api/abstract_api.dart';
import '../../api/params.dart';
import '../../api/response.dart';
import '../../locator.dart';
import '../../models/gesture.dart';
import '../main_cubit.dart';

part 'learned_state.dart';

class LearnedCubit extends MainCubit {
  List<GestureModel> searchResults = [];

  @override
  List<String> get preloadStores => ['user', 'gestures', 'favorites'];

  int page = 1;
  int total = 0;
  int perPage = 30;
  late AbstractApi api;

  LearnedCubit() : super() {
    api = locator<AbstractApi>();
  }

  Future<void> getFavorites(int pageKey) async {
    emit(Loading());

    searchResults = await store.favorites.getFavorites(store.user.user.id, Params({}, {'page': pageKey}));
    page = store.favorites.page;
    total = store.favorites.total;
    perPage = store.favorites.perPage;

    emit(Loaded());
  }

  // Future<void> search(String word, int pageKey) async {
  //   emit(Loading());
  //
  //   searchResults = await store.favorites.search(store.user.user.id, word, pageKey);
  //
  //   page = pageKey;
  //   total = searchResults.length;
  //   perPage = searchResults.length;
  //
  //   emit(Loaded());
  // }

  bool isLastPage() {
    int totalPages = (total/perPage).ceil();
    totalPages = totalPages == 0 ? 1 : totalPages;

    return page == totalPages;
  }
}
