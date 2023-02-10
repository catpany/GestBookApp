import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sigest/views/widgets/link_button.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';

class AuthScreen extends StatelessWidget {

  final String title = '';
  final String socialsText = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthCubit cubit = AuthCubit();

  AuthScreen({Key? key}) : super(key: key);

  List<TextFormFieldWidget> renderFields() {
    return [];
  }

  List<ButtonWidget> renderButtons() {
    return [];
  }

  List<LinkButtonWidget> renderLinks() {
    return [];
  }

  List<IconButton> renderSocials() {
    return [
      IconButton(
        padding: EdgeInsets.zero,
          onPressed: () => {log('press on google')},
          icon: const Icon(
            FontAwesomeIcons.google,
            size: 50,
            color: Colors.white,
          )
      ),
      IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => {log('press on telegram')},
          icon: const Icon(
            FontAwesomeIcons.telegram,
            size: 50,
            color: Colors.white,
          )
      )
    ];
  }

  @override
  build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xffff9671), Color(0xffff6f91)])),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                      Container(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        margin: const EdgeInsets.only(bottom: 17),
                        child: Text(
                            title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 21,
                              fontFamily: 'Jost',
                              height: 1.4,
                            )
                        ),
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: renderFields(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 21,
                              bottom: 10,
                            ),
                            child: Column(
                              children: renderButtons(),
                            )
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                    width: 260,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: renderLinks(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 12,
                    ),
                    child: Text(
                          socialsText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jost',
                            fontSize: 14.0,
                            height: 1.4,
                          ),
                        ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 142,
                    ),
                    margin: const EdgeInsets.only(top: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: renderSocials(),
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
}
