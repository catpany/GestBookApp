import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../styles.dart';
import 'button.dart';

class PagedListWidget extends StatelessWidget {
  final Key refreshKey;
  final PagingController pagingController;
  Widget Function(dynamic item) buildItem;
  final bool isLoading;
  String onEmptyText;

  PagedListWidget(
      {Key? key,
      required this.refreshKey,
      required this.pagingController,
      required this.buildItem,
      required this.isLoading,
      required this.onEmptyText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      color: ColorStyles.gray,
      onRefresh: () => Future.sync(
        () {
          log('refresh');
          pagingController.refresh();
        },
      ),
      child: PagedListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          firstPageProgressIndicatorBuilder: (BuildContext context) {
            if (isLoading) {
              return Center(
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      width: 40,
                      height: 40,
                      child: const CircularProgressIndicator(
                          color: ColorStyles.grayDark)));
            }
            return const SizedBox.shrink();
          },
          itemBuilder: (BuildContext context, item, int index) =>
              buildItem(item),
          firstPageErrorIndicatorBuilder: (context) => Column(children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text(pagingController.error.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.apply(color: ColorStyles.gray))),
            ButtonWidget(
              onClick: () => pagingController.refresh(),
              text: 'Повторить',
              color: ColorStyles.white,
              height: 40,
              minWidth: 140,
              backgroundColor: ColorStyles.grayDark,
            )
          ]),
          noItemsFoundIndicatorBuilder: (context) => Container(
            height: MediaQuery.of(context).size.height/2,
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(onEmptyText,
                    style: TextStyles.title18Medium
                        .apply(color: ColorStyles.gray))),
          ),
        ),
      ),
      // )
    );
  }
}
