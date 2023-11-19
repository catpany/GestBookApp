import 'package:flutter/material.dart';

import '../../helpers/validator.dart';
import '../styles.dart';

enum FieldType { password, text }

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final Function? onFieldTap;
  final String title;
  final Color? titleColor;
  final Color borderColor;
  final FieldType type;
  final String rules;
  final String? errorText;
  final Function(String)? onChanged;

  const TextFormFieldWidget({
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
    this.titleColor,
    this.type = FieldType.text,
    this.rules = '',
    this.errorText,
    this.borderColor = Colors.white,
    this.onChanged,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  double bottomPaddingToError = 20;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  Widget renderIcon() {
    if (widget.type == FieldType.password) {
      return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: true == obscureText
            ? Icon(
                Icons.visibility,
                size: 24,
                color: widget.borderColor,
              )
            : Icon(
                Icons.visibility_off,
                size: 24,
                color: widget.borderColor,
              ),
        onPressed: () => toggleTextShow(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void toggleTextShow() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: ColorStyles.white,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          obscureText: obscureText,
          obscuringCharacter: "\u25cf",
          // or "\u2b24"
          keyboardType: widget.textInputType,
          textInputAction: widget.actionKeyboard,
          focusNode: widget.focusNode,
          style: widget.type == FieldType.password && obscureText
              ? Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: widget.borderColor)
              : Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: renderIcon(),
            hintText: widget.hintText.toUpperCase(),
            errorText: widget.errorText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.borderColor,
                width: 3,
              ),
            ),
            hintStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.apply(color: widget.titleColor),
            contentPadding: const EdgeInsets.only(
                top: 10, bottom: 10, left: 2, right: 14.0),
            isDense: true,
            errorMaxLines: 2,
            errorStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.apply(color: ColorStyles.red, overflow: TextOverflow.visible),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorStyles.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorStyles.red,
                width: 3,
              ),
            ),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: widget.controller,
          validator: (value) {
            return Validator.validate(widget.rules, value ?? '');
          },
          onFieldSubmitted: (value) {
            widget.onSubmitField != null ? widget.onSubmitField!() : {};
          },
          onTap: () {
            widget.onFieldTap != null ? widget.onFieldTap!() : {};
          },
          onChanged: (value) {
            widget.onChanged != null ? widget.onChanged!(value) : {};
          },
        ),
      ),
    );
  }
}
