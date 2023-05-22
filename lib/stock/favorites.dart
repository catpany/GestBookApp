import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/models/favorites.dart';
import 'package:sigest/models/gesture.dart';
import 'package:sigest/stock/gestures.dart';
import 'package:sigest/stock/hive_stock.dart';
import 'package:stock/stock.dart';

import '../api/params.dart';
import '../api/response.dart';
import '../locator.dart';
import 'abstract_repository.dart';

@Named('favorites')
@LazySingleton(as: AbstractRepository)
class FavoritesRepository extends HiveStock<FavoritesModel> {
  @override
  String get name => 'favorites';
  int page = 1;
  int total = 0;
  int perPage = 30;

  Future<List<GestureModel>> getFavorites(String userId, Params params) async {
    FavoritesModel favorites = await stock.get(userId);
    int favoritesLength = favorites.items.length;

    if (favoritesLength > total) {
      page = 1;
      total = favoritesLength;
    } else if (favoritesLength < total && params.body['page'] != page) {
      Response response = await api.favorites(params);

      if (response is ErrorResponse) {
        throw StockResponseError(ResponseOrigin.fetcher, response);
      }

      response = response as SuccessResponse;

      page = response.page ?? 1;
      total = response.total ?? 0;
      perPage = response.perPage ?? 30;

      GestureRepository rep = locator.get<AbstractRepository>(
          instanceName: 'gestures') as GestureRepository;
      await rep.init();
      List<GestureModel> newGestures = [];

      for (var gesture in response.data) {
        GestureModel gestureItem = GestureModel.fromJson(gesture);
        rep.put(gestureItem.id, gestureItem);

        if (favorites.items.contains(gestureItem)) {
          newGestures.add(gestureItem);
          favorites.items.add(gestureItem);
        }
      }

      return newGestures;
    }

    return favorites.items;
  }

  Future<List<GestureModel>> refresh(String userId) async {
    FavoritesModel favorites = await stock.get(userId);

    Response response = await api.favorites(Params({}, {'page': 1}));

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;

    page = response.page ?? 1;
    total = response.total ?? 0;
    perPage = response.perPage ?? 30;

    GestureRepository rep = locator.get<AbstractRepository>(
        instanceName: 'gestures') as GestureRepository;
    await rep.init();
    List<GestureModel> newGestures = [];

    for (var gesture in response.data) {
      GestureModel gestureItem = GestureModel.fromJson(gesture);
      rep.put(gestureItem.id, gestureItem);

      if (favorites.items.contains(gestureItem)) {
        newGestures.add(gestureItem);
        favorites.items.add(gestureItem);
      }
    }

    return newGestures;
  }

  GestureModel? findById(String userId, String gestureId) {
    FavoritesModel? dictionary = store.get(userId);

    if (null != dictionary) {
      for (GestureModel gesture in dictionary.items) {
        if (gestureId == gesture.id) {
          return gesture;
        }
      }
    }

    return null;
  }

  Future<List<GestureModel>> find(String userId, String word) async {
    List<GestureModel> gestures = [];
    FavoritesModel favorites = await stock.get(userId);

    for (var gesture in favorites.items) {
      if (gesture.name.contains(word)) {
        gestures.add(gesture);
      }
    }

    return gestures;
  }

  Future<List<GestureModel>> search(
      String userId, String word, int keyPage) async {
    FavoritesModel favorites = await stock.get(userId);

    Response response = await api.searchFavorites(Params(
        {'page': keyPage.toString(), 'dictionary': favorites.id, 'name': word},
        {}));

    if (response is ErrorResponse) {
      List<GestureModel> gestures = await find(userId, word);

      page = 1;
      total = gestures.length;
      perPage = 30;

      return gestures;
    }

    response as SuccessResponse;

    page = response.page ?? 1;
    total = response.total ?? 0;
    perPage = response.perPage ?? 30;

    List<GestureModel> gestures = [];

    for (var gesture in response.data['list']) {
      GestureModel gestureItem = GestureModel.fromJson(gesture);
      gestures.add(gestureItem);
    }

    return gestures;
  }

  @override
  Future<FavoritesModel> load(String key, Params? params) async {
    this.params = params;
    return stock.get(key);
  }

  @override
  Future<FavoritesModel> loadModel(String key) async {
    Response response =
        await api.favorites(params ??= Params({}, {'page': page}));

    if (response is ErrorResponse) {
      throw StockResponseError(ResponseOrigin.fetcher, response);
    }

    response = response as SuccessResponse;

    page = response.page ?? 1;
    total = response.total ?? 0;
    perPage = response.perPage ?? 30;

    GestureRepository rep = locator.get<AbstractRepository>(
        instanceName: 'gestures') as GestureRepository;
    await rep.init();
    List<GestureModel> gestures = [];

    for (var gesture in response.data['gestures']) {
      GestureModel gestureItem = GestureModel.fromJson(gesture);
      rep.put(gestureItem.id, gestureItem);
      gestures.add(gestureItem);
    }

    FavoritesModel favorites = FavoritesModel(
        id: response.data['id'],
        items: HiveList<GestureModel>(rep.store, objects: gestures));

    return favorites;
  }

  Future<bool> removeFromFavorites(String userId, GestureModel gesture) async {
    Response response =
        await api.removeFromFavorites(Params({}, {'gesture': gesture.id}));

    if (response is ErrorResponse) {
      return false;
    }

    return true;
  }

  Future<bool> deleteFromFavorites(String userId, GestureModel gesture) async {
    FavoritesModel? favorites = store.get(userId);

    if (favorites == null) {
      return false;
    }

    if (favorites.items.remove(gesture)) {
      bool needToDelete = !(await isInFavorites(gesture));

      if (needToDelete) {
        GestureRepository rep = locator.get<AbstractRepository>(
            instanceName: 'gestures') as GestureRepository;
        await rep.init();

        rep.store.delete(gesture.id);
      }

      return true;
    }

    return false;
  }

  Future<bool> isInFavorites(GestureModel gesture) async {
    GestureRepository rep = locator.get<AbstractRepository>(
        instanceName: 'gestures') as GestureRepository;
    await rep.init();

    if (rep.store.values.contains(gesture)) {
      return true;
    }

    return false;
  }

  Future<bool> addToFavorites(String userId, GestureModel gesture) async {
    Response response =
        await api.addToFavorites(Params({}, {'gesture': gesture.id}));

    if (response is ErrorResponse) {
      return false;
    }

    return true;
  }

  Future<bool> saveInFavorites(String userId, GestureModel gesture) async {
    FavoritesModel? favorites = store.get(userId);

    if (favorites == null) {
      return false;
    }

    GestureRepository rep = locator.get<AbstractRepository>(
        instanceName: 'gestures') as GestureRepository;
    await rep.init();

    rep.store.put(gesture.id, gesture);
    favorites.items.add(gesture);
    favorites.save();

    return true;
  }
}
