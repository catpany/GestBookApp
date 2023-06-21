import 'dart:developer';

import 'package:flutter/material.dart';

import '../styles.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: const SizedBox(
        width: 100,
          height: 100,
          child: CircularProgressIndicator(
        color: ColorStyles.gray,
            strokeWidth: 5,
      ))
    );
  }
}
