import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController controller;
  final Function? functionValidate;
  final String parametersValidate;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final Function? onFieldTap;
  final String title;
  final Color titleColor;

  const TextFormFieldWidget({
    Key? key,
    required this.hintText,
    this.focusNode,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    required this.controller,
    required this.functionValidate,
    this.parametersValidate = '',
    this.actionKeyboard = TextInputAction.next,
    this.onSubmitField,
    required this.onFieldTap,
    this.prefixIcon,
    this.title = '',
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  double bottomPaddingToError = 20;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: widget.titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.0,
                  fontFamily: 'Jost',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              constraints: const BoxConstraints(
                minHeight: 0,
                minWidth: 200,
                maxHeight: 61,
                maxWidth: 248,
              ),
              child: TextFormField(
                obscureText: widget.obscureText,
                keyboardType: widget.textInputType,
                textInputAction: widget.actionKeyboard,
                focusNode: widget.focusNode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.0,
                  height: 1.4,
                  fontFamily: 'Jost',
                ),
                decoration: InputDecoration(
                  prefixIcon: widget.prefixIcon,
                  hintText: widget.hintText,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Colors.white,
                      )),
                  hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.0,
                      height: 1.4,
                      fontFamily: 'Jost'),
                  contentPadding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 14,
                      right: 14.0
                  ),
                  isDense: true,
                  errorStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.0,
                    fontFamily: 'Jost',
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                controller: widget.controller,
                validator: (value) {
                  String? resultValidate =
                  widget.functionValidate!(value, widget.parametersValidate);
                  if (resultValidate != null) {
                    return resultValidate;
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  widget.onSubmitField!();
                },
                onTap: () {
                  widget.onFieldTap!();
                },
              )
            )

          ]),
    );
  }
}
