import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Image.asset('assets/images/book_load.gif',
              width: 150, height: 150),
    );
  }
}
