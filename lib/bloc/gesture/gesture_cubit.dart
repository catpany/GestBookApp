import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:sigest/models/gesture-info.dart';

import '../../api/response.dart';
import '../../models/gesture.dart';
import '../main_cubit.dart';

part 'gesture_state.dart';

class GestureCubit extends MainCubit {
  String gestureId;

  @override
  List<String> get preloadStores =>
      ['gestureInfo', 'gestures', 'favorites', 'saved', 'user'];

  GestureCubit({required this.gestureId}) : super();

  @override
  Future<void> load() async {
    log('load');
    emit(DataLoading());
    store.load().then((value) async {
      await loadGesture();
      await store.saved.load(store.user.user.id, null);
    }, onError: (error, StackTrace stackTrace) {
      log(error.toString());
      checkForError(error.error as ErrorResponse);
    });
  }

  Future<void> loadGesture() async {
    GestureInfoModel? gesture =
        store.saved.findById(store.user.user.id, gestureId);

    if (null != gesture && store.gestureInfo.gestureInfo != gesture) {
      store.gestureInfo.gestureInfo = GestureInfoModel(
          id: gesture.id,
          name: gesture.name,
          context: gesture.context,
          description: gesture.description,
          img: gesture.img,
          src: gesture.src);
      emit(DataLoaded());
    } else {
      store.gestureInfo.reload(gestureId, null).then((value) {
        emit(DataLoaded());
      }, onError: (error, StackTrace stacktrace) {
        log(error.toString());
        checkForError(error.error as ErrorResponse);
      });
    }
  }

  bool isSaved() {
    return store.saved
            .findById(store.user.user.id, store.gestureInfo.gestureInfo.id) !=
        null;
  }

  bool isFavorite() {
    return store.favorites
            .findById(store.user.user.id, store.gestureInfo.gestureInfo.id) !=
        null;
  }

  Future<void> save() async {
    emit(Saving());

    bool saved = await store.saved
        .addToSaved(store.user.user.id, store.gestureInfo.gestureInfo);

    saved ? emit(Saved()) : emit(NotSaved());
  }

  Future<void> addToFavorites() async {
    emit(AddingToFavorites());

    GestureModel gesture = GestureModel(
        id: store.gestureInfo.gestureInfo.id,
        name: store.gestureInfo.gestureInfo.name,
        context: store.gestureInfo.gestureInfo.context);

    await store.favorites.saveInFavorites(store.user.user.id, gesture);

    bool added =
        await store.favorites.addToFavorites(store.user.user.id, gesture);

    if (!added) {
      await store.favorites.deleteFromFavorites(store.user.user.id, gesture);
      emit(NotAddedToFavorites());
    } else {
      emit(AddedToFavorites());
    }
  }

  Future<void> removeFromSaved() async {
    emit(DeletingFromSaved());

    bool deleted = await store.saved
        .removeFromSaved(store.user.user.id, store.gestureInfo.gestureInfo.id);

    deleted ? emit(DeletedFromSaved()) : emit(NotDeletedFromSaved());
  }

  Future<void> removeFromFavorites() async {
    emit(DeletingFromFavorites());

    GestureModel gesture = GestureModel(
        id: store.gestureInfo.gestureInfo.id,
        name: store.gestureInfo.gestureInfo.name,
        context: store.gestureInfo.gestureInfo.context);

    await store.favorites.deleteFromFavorites(store.user.user.id, gesture);

    bool deleted =
        await store.favorites.removeFromFavorites(store.user.user.id, gesture);

    if (!deleted) {
      await store.favorites.saveInFavorites(store.user.user.id, gesture);
      emit(NotDeletedFromFavorites());
    } else {
      emit(DeletedFromFavorites());
    }
  }
}
