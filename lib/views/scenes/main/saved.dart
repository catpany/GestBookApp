import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../bloc/saved/saved_cubit.dart';
import '../../../models/gesture-info.dart';
import '../../styles.dart';
import '../../widgets/paged_list.dart';
import '../../widgets/search.dart';
import '../gesture.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  final PagingController _pagingController =
      PagingController<int, GestureInfoModel>(firstPageKey: 1);
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<SavedCubit>().load();
    _pagingController.addPageRequestListener((pageKey) {
      load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _navigateToGestureScreen(String gestureId) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GestureScreen(gestureId: gestureId);
    }));
  }

  void search() {
    context.read<SavedCubit>().search(_searchController.text);
  }

  void load() {
    if (context.read<SavedCubit>().state is! DataLoading) {
      context.read<SavedCubit>().loadDictionary();
    }
  }

  void onSearchChange(String word) {
    if ('' == word) {
      _pagingController.refresh();
    }
  }

  Widget _renderMenuPopup(GestureInfoModel gesture) {
    return PopupMenuButton(
      iconSize: 20,
      elevation: 3,
      icon: const Icon(Icons.more_vert, color: ColorStyles.grayDark),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'delete',
            child:
                Text('Удалить', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              log('tap on delete');
              context.read<SavedCubit>().delete(gesture.id);
              _pagingController.itemList?.remove(gesture);
            },
          ),
        ];
      },
    );
  }

  String getContext(String context) {
    return context == '' ? '' : ' (' + context + ')';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedCubit, MainState>(listener: (context, state) {
      if (state is DataLoaded) {
        load();
      }

      if (state is Searched) {
        final isLastPage = context.read<SavedCubit>().isLastPage();
        final newItems = context.read<SavedCubit>().searchResults;

        if (context.read<SavedCubit>().page == 1) {
          _pagingController.itemList = <GestureInfoModel>[];
        }

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = context.read<SavedCubit>().page + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    }, builder: (context, state) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SearchWidget(
                    searchController: _searchController,
                    onSearch: () => search(),
                    onChange: onSearchChange,
                  )),
              Expanded(
                  child: PagedListWidget(
                      refreshKey: refreshKey,
                      onEmptyText: 'НЕТ СОХРАНЕННЫХ ЖЕСТОВ',
                      pagingController: _pagingController,
                      buildItem: (item) {
                        item as GestureInfoModel;
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: Text(item.name + getContext(item.context),
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis),
                          onTap: () {
                            log('tap on gesture');
                            _navigateToGestureScreen(item.id);
                          },
                          trailing: _renderMenuPopup(item),
                        );
                      },
                      isLoading: context.read<SavedCubit>().state is Searching))
            ],
          ));
    });
  }
}
