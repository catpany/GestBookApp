import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../bloc/learned/learned_cubit.dart';
import '../../../models/gesture.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/paged_list.dart';

class LearnedScreen extends StatefulWidget {
  const LearnedScreen({Key? key}) : super(key: key);

  @override
  _LearnedScreenState createState() => _LearnedScreenState();
}

class _LearnedScreenState extends State<LearnedScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  final PagingController _pagingController =
      PagingController<int, GestureModel>(firstPageKey: 1);
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<LearnedCubit>().load();
    _pagingController.addPageRequestListener((pageKey) {
      log('update list 4');
      search(pageKey);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void search(int pageKey) {
    context.read<LearnedCubit>().search(_searchController.text, pageKey);
  }

  Widget _renderStartButton() {
    int length = _pagingController.itemList?.length ?? 0;
    return Positioned(
        bottom: 8,
        right: 0,
        left: 0,
        child: Center(
            child: ButtonWidget(
          onClick: () {
            if (length > 0) {
              log('start');
            }
          },
          color: Colors.white,
          backgroundColor: length > 0 ? ColorStyles.green : ColorStyles.gray,
          text: 'повторить',
          minWidth: 196,
          height: 40,
        )));
  }

  String getContext(String context) {
    return context == '' ? '' : ' (' + context + ')';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LearnedCubit, MainState>(listener: (context, state) {
      if (state is DataLoaded) {
        search(1);
      }

      if (state is Loaded) {
        final isLastPage = context.read<LearnedCubit>().isLastPage();
        final newItems = context.read<LearnedCubit>().searchResults;

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = context.read<LearnedCubit>().page + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }

      if (state is Error) {
        _pagingController.error = state.error.message;
      }

      if (state is DataLoadingError) {
        _pagingController.error = 'Ошибка загрузки данных';
      }
    }, builder: (context, state) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Stack(
            children: [
              PagedListWidget(
                  refreshKey: refreshKey,
                  pagingController: _pagingController,
                  onEmptyText: 'НЕТ ВЫУЧЕННЫХ ЖЕСТОВ',
                  buildItem: (item) {
                    item as GestureModel;
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: 10),
                      title: Text(item.name + getContext(item.context),
                          style: Theme.of(context).textTheme.bodySmall),
                      onTap: () => log('tap on gesture'),
                    );
                  },
                  isLoading: context.read<LearnedCubit>().state is Loading),
              _renderStartButton(),
            ],
          ));
    });
  }
}
