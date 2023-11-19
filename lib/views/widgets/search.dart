import 'package:flutter/material.dart';

import '../styles.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function onSearch;
  final Function(String)? onChange;

  const SearchWidget(
      {Key? key,
      required this.searchController,
      required this.onSearch,
      this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  bool _validated = true;
  late FocusNode searchNode;

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();

    // listen to focus changes
    // FocusScope.of(context).requestFocus(focusNode);
    searchNode.addListener(() {
      print('focusNode updated: hasFocus: ${searchNode.hasFocus}');
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    searchNode.dispose();
    super.dispose();
  }

  void submit(value) {
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

  Widget _renderButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.searchController.text != ''
            ? IconButton(
                icon: const Icon(Icons.close,
                    color: ColorStyles.grayDark, size: 20),
                onPressed: () {
                  widget.searchController.clear();
                  setState(() {});
                  // _pagingController.refresh();
                },
              )
            : const SizedBox.shrink(),
        GestureDetector(
            onTap: () {
              submit(widget.searchController.text);
              FocusManager.instance.primaryFocus?.unfocus();
              // _pagingController.refresh();
            },
            child: AnimatedContainer(
              alignment: AlignmentDirectional.center,
              width: searchNode.hasFocus ? 30 : 0,
              height: 30,
              curve: Curves.ease,
              decoration: BoxDecoration(
                color: ColorStyles.accent,
                borderRadius: BorderRadius.circular((5)), // round angle
              ),
              child: searchNode.hasFocus
                  ? const Icon(Icons.search, color: ColorStyles.white, size: 20)
                  : const SizedBox.shrink(),
              duration: const Duration(milliseconds: 200),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodySmall,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {});
      },
      focusNode: searchNode,
      decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodySmall?.apply(
              color: ColorStyles.grayDark, overflow: TextOverflow.visible),
          hintText: 'Найти перевод слова...',
          contentPadding: const EdgeInsets.only(top: 22, left: 5, right: 25),
          suffixIcon: _renderButtons(),
          errorText: !_validated ? 'Пустая строка' : null,
          errorStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.apply(color: ColorStyles.red, overflow: TextOverflow.visible),
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
              width: 3,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: ColorStyles.red,
              width: 3,
            ),
          ),
          suffixIconColor: ColorStyles.gray),
      onSubmitted: (String value) {
        submit(value);
      },
      onChanged: (String val) {
        setState(() {});

        null == widget.onChange ? {} : widget.onChange!(val);
      },
    );
  }
}
