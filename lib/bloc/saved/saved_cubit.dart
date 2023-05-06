import 'dart:developer';

import 'package:meta/meta.dart';

import '../../api/response.dart';
import '../../models/dictionary.dart';
import '../../models/gesture.dart';
import '../main_cubit.dart';

part 'saved_state.dart';

class SavedCubit extends MainCubit {
  @override
  List<String> preloadStores = ['user', 'gestures', 'saved'];
  List<GestureModel> searchResults = [];
  int page = 1;
  int total = 0;
  int perPage = 0;

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

    searchResults = store.saved.find(store.user.user.id, word);
    page = 1;
    total = searchResults.length;
    perPage = searchResults.length;

    emit(Searched());
  }

   void loadDictionary() {
    emit(Searching());
    DictionaryModel? dictionary = store.saved.get(store.user.user.id);

    searchResults = dictionary == null? [] : dictionary.items;
    page = 1;
    total = searchResults.length;
    perPage = searchResults.length;

    emit(Searched());
  }

  bool isLastPage() {
    int totalPages = perPage == 0 ? 1 : (total / perPage).ceil();
    return page == totalPages;
  }

  bool delete(GestureModel gesture) {
    DictionaryModel? dictionary = store.saved.get(store.user.user.id);
    if (dictionary == null) {
      return false;
    }

    return  dictionary.items.remove(gesture);
  }
}
