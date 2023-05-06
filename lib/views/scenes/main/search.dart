import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/bloc/search/search_cubit.dart';
import 'package:sigest/models/word.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../widgets/paged_list.dart';
import '../../widgets/search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  final PagingController _pagingController =
      PagingController<int, WordModel>(firstPageKey: 1);
  bool isInitial = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      log('update list 1');
      log(isInitial.toString());
      if (!isInitial) {
        search(pageKey);
      } else {
        isInitial = false;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> search(int pageKey) async {
    await context.read<SearchCubit>().search(_searchController.text, pageKey);
  }

  String getContext(String context) {
    return context == '' ? '' : ' (' + context + ')';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, MainState>(listener: (context, state) {
      if (state is Searched) {
        // final previouslyFetchedItemsCount =
        //     _pagingController.itemList?.length ?? 0;

        final isLastPage = context.read<SearchCubit>().isLastPage();
        final newItems = context.read<SearchCubit>().searchResults;

        if (context.read<SearchCubit>().page == 1) {
          _pagingController.itemList = <WordModel>[];
        }

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = context.read<SearchCubit>().page + 1;
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
                    onSearch: () => search(1),
                  )),
              Expanded(
                  child: PagedListWidget(
                      refreshKey: refreshKey,
                      pagingController: _pagingController,
                      onEmptyText: 'НИЧЕГО НЕ НАЙДЕНО',
                      buildItem: (item) {
                        item as WordModel;
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 10),
                          title: Text(item.name + getContext(item.context),
                              style: Theme.of(context).textTheme.bodySmall),
                          onTap: () => log('tap on gesture'),
                        );
                      },
                      isLoading:
                          context.read<SearchCubit>().state is Searching))
            ],
          ));
    });
  }
}
