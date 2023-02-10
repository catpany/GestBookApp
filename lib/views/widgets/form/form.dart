import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:sigest/views/widgets/input.dart';

class AuthForm extends StatelessWidget {

  List<TextFormFieldWidget> renderFields() {
    return [];
  }

  List<TextFormFieldWidget> renderButtons() {
    return [];
  }

  @override build(BuildContext context) {
    return Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Column(
              children: renderFields(),
            ),
            Column(
              children: renderButtons(),
            )
          ],
        )
    );
  }
}