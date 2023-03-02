import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sigest/views/widgets/link_button.dart';

import '../../../api.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../styles.dart';
import '../../widgets/input.dart';

class AuthScreen extends StatelessWidget {
  final String title = '';
  final String socialsText = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> bindControllers;

  AuthScreen({Key? key, required this.bindControllers}) : super(key: key);

  List<TextFormFieldWidget> renderFields([Map<String, dynamic>? errors]) {
    return [];
  }

  List<Widget> renderButtons() {
    return [];
  }

  List<LinkButtonWidget> renderLinks() {
    return [];
  }

  List<Widget> renderSocials() {
    return [
      ElevatedButton(
        onPressed: () => {log('press on google')},
        child: const Icon(
          FontAwesomeIcons.google,
          size: 30,
          color: ColorStyles.accent,
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              return null;
            },
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(5)),
          fixedSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          backgroundColor: MaterialStateProperty.all<Color>(ColorStyles.white),
          foregroundColor: MaterialStateProperty.all<Color>(ColorStyles.white),
        ),
      ),
      SizedBox(
          width: 55,
          height: 55,
          child: ElevatedButton(
            onPressed: () => {log('press on vk')},
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0.0)),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: const Icon(
              FontAwesomeIcons.vk,
              size: 55,
              color: ColorStyles.white,
            ),
          ))
    ];
  }

  @override
  build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(bindControllers),
      child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [ColorStyles.orange, ColorStyles.accent])),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: ColorStyles.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      margin: const EdgeInsets.only(bottom: 13),
                      child: Text(title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyles.title21Regular),
                    ),
                    Form(
                        key: formKey,
                        child: Container(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 33),
                            padding: const EdgeInsets.symmetric(
                                vertical: 28, horizontal: 22),
                            decoration: const BoxDecoration(
                                color: Color(0x4dffffff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthError &&
                                          Api.codeErrors[state.error.code] ==
                                              ApiErrors.validationError) {
                                        return Column(
                                          children: renderFields(
                                              state.error.messages),
                                        );
                                      } else {
                                        return Column(
                                          children: renderFields(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  child: BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthError) {
                                        return Container(
                                            margin: EdgeInsets.only(top: 4),
                                            child: Text(
                                              state.error.message,
                                              style: TextStyles.text14SemiBold
                                                  ?.apply(
                                                      color: ColorStyles.red),
                                            ));
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                      top: 44,
                                    ),
                                    child: Column(
                                      children: renderButtons(),
                                    )),
                              ],
                            ))),
                    Container(
                      // width: 260,
                      margin:
                          const EdgeInsets.only(left: 33, right: 33, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: renderLinks(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 14,
                      ),
                      child: Text(
                        socialsText,
                        textAlign: TextAlign.center,
                        style: TextStyles.text14Regular
                            ?.apply(color: ColorStyles.white),
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
                )),
          )),
    );
  }
}
