import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/validator.dart';
import '../styles.dart';

enum FieldType {
  password,
  text
}

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  bool obscureText;
  final TextEditingController? controller;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final Function? onFieldTap;
  final String title;
  final Color titleColor;
  final FieldType type;
  final String rules;
  final String? errorText;

  TextFormFieldWidget({
    Key? key,
    required this.hintText,
    this.focusNode,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    required this.controller,
    this.actionKeyboard = TextInputAction.next,
    this.onSubmitField,
    this.onFieldTap,
    this.prefixIcon,
    this.title = '',
    this.titleColor = Colors.black,
    this.type = FieldType.text,
    this.rules = '',
    this.errorText
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  double bottomPaddingToError = 20;

  Widget renderIcon() {
    if (widget.type == FieldType.password) {
      return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: true == widget.obscureText ?
        const Icon(
          Icons.visibility,
          size: 24,
          color: ColorStyles.white,
        ) :
        const Icon(
          Icons.visibility_off,
          size: 24,
          color: ColorStyles.white,
        ),
        onPressed: () => toggleTextShow(),
      );
    }
    else {
      return const SizedBox.shrink();
    }
  }

  void toggleTextShow() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorStyles.white,
      ),
      child:
      Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: const BoxConstraints(
        minHeight: 0,
        minWidth: 200,
        maxHeight: 93,
        maxWidth: 248,
      ),
      child:
        Stack(
            children: <Widget>[
              TextFormField(
                  obscureText: widget.obscureText,
                  obscuringCharacter: "\u25cf", // or "\u2b24"
                  keyboardType: widget.textInputType,
                  textInputAction: widget.actionKeyboard,
                  focusNode: widget.focusNode,
                  style: widget.type == FieldType.password && widget.obscureText ? TextStyles.text14Regular?.apply(color: ColorStyles.white) : TextStyles.text14Regular,
                  decoration: InputDecoration(
                    prefixIcon: widget.prefixIcon,
                    hintText: widget.hintText.toUpperCase(),
                    errorText: widget.errorText,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorStyles.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorStyles.white,
                        width: 2,
                      ),
                    ),
                    hintStyle: TextStyles.text14Regular?.apply(color: widget.titleColor),
                    contentPadding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 2,
                        right: 14.0
                    ),
                    isDense: true,
                    errorMaxLines: 2,
                    errorStyle: TextStyles.text14Regular?.apply(color: ColorStyles.red, overflow: TextOverflow.visible),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorStyles.red,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorStyles.red,
                        width: 2,
                      ),
                    ),
                  ),
                  controller: widget.controller,
                  validator: (value) {
                    return Validator.validate(widget.rules, value?? '');
                  },
                  onFieldSubmitted: (value) {
                    widget.onSubmitField != null ? widget.onSubmitField!() : {};
                  },
                  onTap: () {
                    widget.onFieldTap != null ? widget.onFieldTap!() : {};
                  },
                ),
              Positioned(
                right: 0,
                top: -2,
                child: renderIcon(),
              ),
            ]),
      ),
    );
  }
}
