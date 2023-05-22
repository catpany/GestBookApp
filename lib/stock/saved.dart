import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sigest/models/gesture-info.dart';
import 'package:sigest/stock/gesture-info.dart';
import 'package:sigest/stock/hive_repository.dart';
import 'dart:io';

import '../api/params.dart';
import '../api/response.dart';
import '../locator.dart';
import '../models/saved.dart';
import 'abstract_repository.dart';

@Named('saved')
@Singleton(as: AbstractRepository)
class SavedRepository extends HiveRepository<SavedModel> {
  @override
  String get name => 'saved';

  List<GestureInfoModel> findByName(String userId, String word) {
    List<GestureInfoModel> gestures = [];

    store.get(userId)?.items.forEach((GestureInfoModel gesture) {
      if (gesture.name.toLowerCase().contains(word.toLowerCase())) {
        gestures.add(gesture);
      }
    });

    return gestures;
  }

  GestureInfoModel? findById(String userId, String gestureId) {
    SavedModel? dictionary = store.get(userId);

    if (null != dictionary) {
      for (GestureInfoModel gesture in dictionary.items) {
        if (gestureId == gesture.id) {
          return gesture;
        }
      }
    }
    
    return null;
  }

  @override
  dynamic load(String key, Params? params) async {
    this.params = params;
    SavedModel? dictionary = store.get(key);

    if (dictionary == null) {
      GestureInfoRepository rep = locator.get<AbstractRepository>(instanceName: 'gestureInfo') as GestureInfoRepository;
      await rep.init();
      dictionary = SavedModel(items: HiveList(rep.store));
      await store.put(key, dictionary);
    }

    return dictionary;
  }

  Future<bool> removeFromSaved(String userId, String gestureId) async {
    SavedModel? dictionary = get(userId);
    if (dictionary == null) {
      return false;
    }
    
    GestureInfoModel? gesture = findById(userId, gestureId);

    if (null != gesture && dictionary.items.remove(gesture)) {
      bool needToDelete = !(await isInSaved(gesture));

      if (needToDelete) {
        GestureInfoRepository rep = locator.get<AbstractRepository>(instanceName: 'gestureInfo') as GestureInfoRepository;
        await rep.init();

        if (null != gesture.src) {
          File(gesture.src ?? '').delete();
        }

        if (null != gesture.img) {
          File(gesture.img ?? '').delete();
        }

        rep.store.delete(gesture.id);
      }

      return true;
    }

    return false;
  }

  Future<bool> isInSaved(GestureInfoModel gesture) async {
    for (var saved in store.values) {
      if (saved.items.contains(gesture)) {
        return true;
      }
    }

    return false;
  }

  Future<bool> addToSaved(String userId, GestureInfoModel gesture) async {
    SavedModel? saved = store.get(userId);

    if (saved == null) {
      return false;
    }

    GestureInfoModel savedGesture = GestureInfoModel(id: gesture.id, name: gesture.name, context: gesture.context, description: gesture.description, img: gesture.img, src: gesture.src);

    if (null != gesture.src) {
      Response response = await api.downloadVideo(gesture.src ?? '');

      if (response is ErrorResponse) {
        return false;
      }

      savedGesture.src = (response as SuccessResponse).data['path'];
    }

    if (null != gesture.img) {
      Response response = await api.downloadImage(gesture.img ?? '');

      if (response is ErrorResponse) {
        return false;
      }

      savedGesture.img = (response as SuccessResponse).data['path'];
    }

    GestureInfoRepository rep = locator.get<AbstractRepository>(instanceName: 'gestureInfo') as GestureInfoRepository;
    await rep.init();

    await rep.store.put(gesture.id, savedGesture);
    saved.items.add(savedGesture);
    saved.save();

    return true;
  }
}
