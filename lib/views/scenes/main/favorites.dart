import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../bloc/favorites/favorites_cubit.dart';
import '../../../models/gesture.dart';
import '../../styles.dart';
import '../../widgets/paged_list.dart';
import '../../widgets/search.dart';
import '../gesture.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  final PagingController _pagingController =
      PagingController<int, GestureModel>(firstPageKey: 1);
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().load();
    _pagingController.addPageRequestListener((pageKey) {
      searchOrGet(pageKey);
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

  void searchOrGet(int pageKey) {
    if (context.read<FavoritesCubit>().state is! DataLoading) {
      if (_searchController.text != '') {
        context.read<FavoritesCubit>().search(_searchController.text, pageKey);
      } else {
        context.read<FavoritesCubit>().getFavorites(pageKey);
      }
    }
  }

  void onSearchChange(String word) {
    if ('' == word) {
      _pagingController.refresh();
      }
  }

  void refresh() {
    if (context.read<FavoritesCubit>().state is! DataLoading) {
      context.read<FavoritesCubit>().refresh();
    }
  }

  Widget _renderMenuPopup(GestureModel gesture) {
    return PopupMenuButton(
      iconSize: 20,
      elevation: 3,
      icon: const Icon(Icons.more_vert, color: ColorStyles.grayDark),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              value: 'delete',
              child: Text(
                'Удалить',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                log('tap on delete');
                context.read<FavoritesCubit>().delete(gesture);
                _pagingController.itemList?.remove(gesture);
                },
          )
        ];
      },
    );
  }

  String getContext(String context) {
    return context == '' ? '' : ' (' + context + ')';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, MainState>(listener: (context, state) {
      if (state is DataLoaded) {
        searchOrGet(1);
      }

      if (state is Searched) {
        final isLastPage = context.read<FavoritesCubit>().isLastPage();
        log('is last page: ' + isLastPage.toString());
        final newItems = context.read<FavoritesCubit>().searchResults;

        if (context.read<FavoritesCubit>().page == 1) {
          _pagingController.itemList = <GestureModel>[];
        }

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = context.read<FavoritesCubit>().page + 1;
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SearchWidget(
                    searchController: _searchController,
                    onSearch: () => _pagingController.refresh(),
                    onChange: onSearchChange,
                  )),
              Expanded(
                  child: PagedListWidget(
                      refreshKey: refreshKey,
                      pagingController: _pagingController,
                      onEmptyText: 'НЕТ ИЗБРАННЫХ ЖЕСТОВ',
                      buildItem: (item) {
                        item as GestureModel;
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: Text(item.name + getContext(item.context),
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis),
                          onTap: () {
                            _navigateToGestureScreen(item.id);
                          },
                          trailing: _renderMenuPopup(item),
                        );
                      },
                      isLoading: state is Searching))
            ],
          ));
    });
  }
}
