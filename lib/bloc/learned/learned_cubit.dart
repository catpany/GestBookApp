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
  int page = 1;
  int total = 0;
  int perPage = 0;
  late AbstractApi api;

  LearnedCubit() : super() {
    api = locator<AbstractApi>();
  }

  Future<void> search(String word, int pageKey) async {
    emit(Loading());

    Response response = await api.favorites(Params({
      'page': page.toString(),
    }, {}));

    if (!checkForError(response)) {
      response as SuccessResponse;
      page = response.page?? 1;
      total = response.total?? 0;
      perPage = response.perPage?? 1;
      searchResults = [];
      for (var res in (response.data as List<dynamic>)) {
        searchResults.add(GestureModel.fromJson(res));
      }

      emit(Loaded());
    }
  }

  bool isLastPage() {
    int totalPages = (total/perPage).ceil();
    return page == totalPages;
  }
}
