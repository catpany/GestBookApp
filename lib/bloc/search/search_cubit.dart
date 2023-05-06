import 'package:meta/meta.dart';

import '../../api/abstract_api.dart';
import '../../api/params.dart';
import '../../api/response.dart';
import '../../locator.dart';
import '../../models/word.dart';
import '../main_cubit.dart';

part 'search_state.dart';

class SearchCubit extends MainCubit {
  List<WordModel> searchResults = [];
  int page = 1;
  int total = 0;
  int perPage = 0;
  late AbstractApi api;

  SearchCubit() : super() {
    api = locator<AbstractApi>();
  }

  Future<void> search(String word, int page) async {
    emit(Searching());

    Response response = await api.search(Params({
      'page': page.toString(),
      'name': word.toString(),
    }, {}));

    if (!checkForError(response)) {
      response as SuccessResponse;
      this.page = response.page?? 1;
      total = response.total?? 0;
      perPage = response.perPage?? 1;
      searchResults = [];
      for (var res in (response.data as List<dynamic>)) {
        searchResults.add(WordModel.fromJson(res));
      }
      // searchResults = (response.data as List<dynamic>).cast();
      emit(Searched());
    }
  }

  bool isLastPage() {
    int totalPages = (total/perPage).ceil();
    return page == totalPages;
  }
}
