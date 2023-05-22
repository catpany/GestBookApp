import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/models/saved.dart';

import '../../api/response.dart';
import '../../models/gesture-info.dart';
import '../main_cubit.dart';

part 'saved_state.dart';

class SavedCubit extends MainCubit {
  @override
  List<String> get preloadStores => ['user', 'gestureInfo', 'saved'];
  List<GestureInfoModel> searchResults = [];
  int page = 1;
  int total = 0;
  int perPage = 30;

  SavedCubit() : super();

  @override
  Future<void> load() async {
    emit(DataLoading());
    store.load().then((value) async {
      log('static data loaded');
      await store.saved.load(store.user.user.id, null);
      emit(DataLoaded());
    }, onError: (error, StackTrace stackTrace) {
      log('error!');
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  void search(String word) {
    emit(Searching());

    searchResults = store.saved.findByName(store.user.user.id, word);
    page = 1;
    total = searchResults.length;
    perPage = searchResults.length;

    emit(Searched());
  }

  void loadDictionary() {
    emit(Searching());
    SavedModel? saved = store.saved.get(store.user.user.id);

    searchResults = saved == null ? [] : saved.items;
    page = 1;
    total = searchResults.length;
    perPage = searchResults.length;

    emit(Searched());
  }

  bool isLastPage() {
    int totalPages = perPage == 0 ? 1 : (total / perPage).ceil();
    totalPages = totalPages == 0 ? 1 : totalPages;

    return page == totalPages;
  }

  void delete(String gestureId) async {
    emit(Deleting());

    bool deleted =
        await store.saved.removeFromSaved(store.user.user.id, gestureId);

    deleted ? emit(Deleted()) : emit(NotDeleted());
  }
}
