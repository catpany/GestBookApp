import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/gesture/gesture_cubit.dart';
import '../../bloc/main_cubit.dart';
import '../../main.dart';
import '../styles.dart';
import '../widgets/video_player.dart';
import '../widgets/widget_wrapper.dart';

class GestureScreen extends StatefulWidget {
  final String gestureId;

  GestureScreen({Key? key, required this.gestureId}) : super(key: key) {
    // cubit = GestureCubit(gestureId: gestureId);
  }

  @override
  State<StatefulWidget> createState() => GestureScreenState();
}

class GestureScreenState extends State<GestureScreen> {
  late final GestureCubit cubit = GestureCubit(gestureId: widget.gestureId);

  @override
  void initState() {
    super.initState();
    cubit.load();
  }

  PreferredSizeWidget _renderTopBar(BuildContext context, MainState state) {
    log(state.toString());
    return AppBar(
        title: const Text('СЛОВАРЬ', style: TextStyles.title18Medium),
        backgroundColor: ColorStyles.accent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        actions: [
          state is! DataLoading
              ? _renderSaveButton(state)
              : const SizedBox.shrink(),
          state is! DataLoading
              ? Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _renderFavoriteButton(state))
              : const SizedBox.shrink(),
        ]);
  }

  Widget _renderSaveButton(MainState state) {
    if (!cubit.isSaved()) {
      return IconButton(
        tooltip: 'Сохранить',
        icon: Icon(Icons.file_download_outlined,
            color: state is Saving ? ColorStyles.gray : Colors.white),
        onPressed: () {
          if (state is! Saving) {
            log('press save');
            cubit.save();
          }
        },
      );
    }

    return IconButton(
      tooltip: 'Удалить из сохраненного',
      icon: Icon(Icons.file_upload_outlined,
          color: state is DeletingFromSaved ? ColorStyles.gray : Colors.white),
      onPressed: () {
        if (state is! DeletingFromSaved) {
          log('press remove from saved');
          cubit.removeFromSaved();
        }
      },
    );
  }

  Widget _renderFavoriteButton(MainState state) {
    if (!cubit.isFavorite()) {
      return IconButton(
        tooltip: 'Добавить в избранное',
        icon: Icon(Icons.star_border_rounded,
            color:
                state is AddingToFavorites ? ColorStyles.gray : Colors.white),
        onPressed: () {
          if (state is! AddingToFavorites) {
            log('press add favorite');
            cubit.addToFavorites();
          }
        },
      );
    }

    return IconButton(
      tooltip: 'Удалить из избранного',
      icon: Icon(Icons.star_rounded,
          color:
              state is DeletingFromFavorites ? ColorStyles.gray : Colors.white),
      onPressed: () {
        if (state is! DeletingFromFavorites) {
          log('press remove from favorite');
          cubit.removeFromFavorites();
        }
      },
    );
  }

  Widget _showContent() {
    String src;

    if (cubit.store.gestureInfo.gestureInfo.src != null) {
      src = cubit.store.gestureInfo.gestureInfo.src ?? '';

      if (src.startsWith('http')) {
        return VideoPlayerWidget(
            src: src.replaceAll('localhost:8000', config["domain"]));
      }

      return VideoPlayerWidget(
        src: src,
        fromNetwork: false,
      );
    }

    if (cubit.store.gestureInfo.gestureInfo.img != null) {
      src = cubit.store.gestureInfo.gestureInfo.img ?? '';

      if (src.startsWith('http')) {
        return Image.network(
          src.replaceAll('localhost:8000', config["domain"]),
          errorBuilder: (BuildContext context, error, _) => _showError(),
          frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
            return _loadingFrame(child);
          },
        );
      }

      return Image.file(
        File(src),
        errorBuilder: (BuildContext context, error, _) => _showError(),
        frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
          return _loadingFrame(child);
        },
      );
    }

    return _showError();
  }

  Widget _loadingFrame(Widget child) {
    return Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 212,
        ),
        decoration: const BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: child,
        ));
  }

  Widget _showError() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      alignment: AlignmentDirectional.center,
      width: double.infinity,
      height: 212,
      child: Text(
        'Ресурс недоступен',
        style: TextStyles.title20SemiBold?.apply(color: ColorStyles.grayDark),
      ),
    );
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is! DataLoading) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Text(cubit.store.gestureInfo.gestureInfo.name,
                      style: Theme.of(context).textTheme.headlineMedium)),
              _showContent(),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: WidgetWrapper(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 18),
                    child: Text(cubit.store.gestureInfo.gestureInfo.description,
                        style: Theme.of(context).textTheme.bodySmall),
                  ))
            ],
          )));
    }

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 100,
            height: 20,
            decoration: const BoxDecoration(
                color: ColorStyles.gray,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 20),
            width: double.infinity,
            height: 212,
            decoration: const BoxDecoration(
                color: ColorStyles.gray,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Container(
            width: double.infinity,
            height: 140,
            decoration: const BoxDecoration(
                color: ColorStyles.gray,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => cubit,
        child: BlocConsumer<GestureCubit, MainState>(
            bloc: cubit,
            listener: (BuildContext context, state) {
              if (state is Error) {}
            },
            builder: (BuildContext context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: _renderTopBar(context, state),
                  body: _renderBody(context, state));
            }));
  }
}
