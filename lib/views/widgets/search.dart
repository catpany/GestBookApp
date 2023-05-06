import 'dart:developer';

import 'package:flutter/material.dart';

import '../styles.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function onSearch;

  const SearchWidget({Key? key, required this.searchController, required this.onSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  bool _validated = true;

  void submit(value) {
    log(value);
    if (value != '') {
      setState(() {
        _validated = true;
      });
      widget.onSearch();
    } else {
      setState(() {
        _validated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.only(top: 22, left: 12),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              log('tap on search');
              submit(widget.searchController.text);
              // _pagingController.refresh();
            },
          ),
          errorText: !_validated ? 'Пустая строка' : null,
          errorStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.apply(
              color: ColorStyles.red,
              overflow: TextOverflow.visible),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorStyles.red,
              width: 2,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorStyles.gray,
              width: 2,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorStyles.accent,
              width: 2,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorStyles.red,
              width: 2,
            ),
          ),
          suffixIconColor: ColorStyles.gray),
      onSubmitted: (String value) {
        log(value);
        log('submit');
        submit(value);
          // _pagingController.itemList = null;
          // search(1);
      },
    );
  }

}