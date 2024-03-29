import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sigest/views/widgets/link_button.dart';
import 'package:sigest/views/widgets/notification.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

import '../../../api/response.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/main_cubit.dart';
import '../../styles.dart';

class AuthScreen extends StatelessWidget {
  final String title = '';
  final String socialsText = '';
  final bool showSocials = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> bindControllers;
  late final AuthCubit cubit;
  final bool showAppBar = false;

  AuthScreen({Key? key, required this.bindControllers}) : super(key: key) {
    cubit = AuthCubit(bindControllers);
    cubit.load();
  }

  List<Widget> renderFields([Map<String, dynamic>? errors]) {
    return [];
  }

  List<Widget> renderButtons(BuildContext context) {
    return [];
  }

  List<LinkButtonWidget> renderLinks() {
    return [];
  }

  List<Widget> renderSocials() {
    return [
      ElevatedButton(
        onPressed: () {
          log('press on google');
          cubit.authViaGoogle();
        },
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
          shape:
              MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(5)),
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
            onPressed: () {
              log('press on vk');
              cubit.authViaVK();
            },
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(0.0)),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: const Icon(
              FontAwesomeIcons.vk,
              size: 55,
              color: ColorStyles.white,
            ),
          ))
    ];
  }

  PreferredSizeWidget? _renderAppBar() {
    if (showAppBar) {
      return AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );
    }

    return null;
  }

  Widget _renderBody(BuildContext context, MainState state) {
    if (state is LinkReceived && (Platform.isAndroid || Platform.isIOS)) {
      WebViewController _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white);
        _controller.setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
            },
            onPageStarted: (String url) {
            },
            onPageFinished: (String url) async {
                String? response = await _controller.runJavaScriptReturningResult("document.querySelector('pre').innerHTML") as String?;
                if (response != null && jsonDecode(response) != null) {
                  dynamic jsonTokens = jsonDecode(jsonDecode(response));
                  print(jsonTokens['access_token'].toString());
                  print(response.toString());
                  cubit.setAuth(jsonTokens);
                } else {
                  print('empty response');
                }
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );
        _controller.loadRequest(Uri.parse(state.link));
      return SizedBox(
          width: double.infinity,
          child: WebViewWidget(
            controller: _controller,
          ));
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _renderTitleBlock(),
        Container(
          height: double.infinity,
          margin: const EdgeInsets.only(top: 144),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    _renderFormBlock(context, state),
                    _renderLinksBlock(),
                  ] +
                  _renderSocialsBlock(context),
            ),
          ),
        ),
        _renderNotificationBlock(state),
        _renderLoadingBlock(context, state),
      ],
    );
  }

  Widget _renderTitleBlock() {
    return SizedBox(
        width: double.infinity,
        height: 144,
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 13),
          child: Text(title.toUpperCase(),
              textAlign: TextAlign.center, style: TextStyles.title21Regular),
        ));
  }

  Form _renderFormBlock(BuildContext context, MainState state) {
    return Form(
        key: formKey,
        child: Container(
            constraints: const BoxConstraints(
              minWidth: double.infinity,
            ),
            margin: const EdgeInsets.only(right: 33, left: 33),
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
            decoration: const BoxDecoration(
                color: Color(0x4dffffff),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _renderFormFieldsBlock(context, state) +
                  [_renderFormButtonsBlock(context, state)],
            )));
  }

  List<Widget> _renderFormFieldsBlock(BuildContext context, MainState state) {
    if (state is Error) {
      if (codeErrors[state.error.code] == ApiErrors.validationError) {
        return renderFields(state.error.messages);
      } else {
        return renderFields() +
            [
              Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    state.error.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.apply(color: ColorStyles.red),
                  ))
            ];
      }
    }
    return renderFields();
  }

  Widget _renderFormButtonsBlock(BuildContext context, MainState state) {
    if (state is DataLoading) {
      return const Padding(
          padding: EdgeInsets.only(
            top: 44,
          ),
          child: CircularProgressIndicator(color: ColorStyles.white));
    }

    return Padding(
        padding: const EdgeInsets.only(
          top: 44,
        ),
        child: Column(
          children: renderButtons(context),
        ));
  }

  Widget _renderLinksBlock() {
    return Container(
      margin: const EdgeInsets.only(left: 33, right: 33, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: renderLinks(),
      ),
    );
  }

  List<Widget> _renderSocialsBlock(BuildContext context) {
    return [
      Container(
        margin: const EdgeInsets.only(
          top: 14,
        ),
        child: Text(
          socialsText,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall
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
          children: showSocials ? renderSocials() : [],
        ),
      )
    ];
  }

  Widget _renderNotificationBlock(state) {
    if (state is CodeResent) {
      return NotificationWidget(text: state.message);
    } else if (state is DataLoadingError) {
      return NotificationWidget(text: state.message);
    }
    return const SizedBox.shrink();
  }

  void navigateTo(BuildContext context, MainState state) {}

  Widget _renderLoadingBlock(BuildContext context, MainState state) {
    if (state is AuthLinkLoading) {
      return Container(
          alignment: AlignmentDirectional.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height + 44,
          color: Colors.black12,
          child: const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(color: ColorStyles.white, strokeWidth: 8,)));
    }

    return const SizedBox.shrink();
  }

  @override
  build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [ColorStyles.orange, ColorStyles.accent])),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: _renderAppBar(),
              body: SafeArea(
                child: BlocConsumer<AuthCubit, MainState>(
                    bloc: cubit,
                    listener: (context, state) {
                      navigateTo(context, state);
                    },
                    builder: (context, state) {
                      return _renderBody(context, state);
                    }),
              ))),
    );
  }
}
