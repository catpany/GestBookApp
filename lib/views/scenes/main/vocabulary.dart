import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/bloc/units/units_cubit.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/unit_list.dart';

import '../../../bloc/vocabulary/vocabulary_cubit.dart';
import '../../widgets/button.dart';

class VocabularyScreen extends StatefulWidget {
  VocabularyScreen({Key? key}) : super(key: key);
  final VocabularyCubit cubit = VocabularyCubit();

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<String> letters = [
    'А',
    'Б',
    'В',
    'Г',
    'Д',
    'Е',
    'Ё',
    'Ж',
    'З',
    'И',
    'Й',
    'К',
    'Л',
    'М',
    'Н',
    'О',
    'П',
    'Р',
    'С',
    'Т',
    'У',
    'Ф',
    'Ц',
    'Ч',
    'Ш',
    'Щ',
    'Ь',
    'Ы',
    'Ъ',
    'Э',
    'Ю',
    'Я',
  ];

  @override
  void initState() {
    super.initState();
    widget.cubit.load();
  }

  PreferredSizeWidget _renderTopBar() {
    return AppBar(
      title: const Text('АЗБУКА ДАКТИЛЯ', style: TextStyles.title18Medium),
      shadowColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorStyles.orange, ColorStyles.accent]))),
    );
  }

  List<Widget> _renderLetters() {
    List<Widget> items = [];

    for (String letter in letters) {
      items.add(
        SizedBox(
          width: 90,
          height: 90,
          child: Stack(children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                border: Border.all(
                  color: ColorStyles.grayDark,
                  width: 4,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: SvgPicture.asset(
                    'assets/images/vocabulary/' + letter + '.svg',
                    width: 62,
                    height: 62)),
            Positioned(
                right: 10,
                bottom: -5,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white.withOpacity(0.9),
                  ),
                )),
            Positioned(
                right: 10,
                bottom: -5,
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                    color: ColorStyles.grayDark,
                  ),
                ))
          ]),
        ),
      );
    }

    return items;
  }

  Widget _renderBody(BuildContext context, MainState state) {
    return Stack(
      children: [
        RawScrollbar(
            thumbColor: ColorStyles.gray,
            padding: const EdgeInsets.only(right: 6),
            radius: const Radius.circular(5),
            thickness: 8,
            child: SingleChildScrollView(
                child: Container(
                    alignment: AlignmentDirectional.topCenter,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 30, bottom: 90),
                    child: Wrap(
                      children: _renderLetters(),
                      spacing: 10,
                      runSpacing: 10,
                    )))),
        // _renderStartButton()
      ],
    );
  }

  Widget _renderStartButton() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 20,
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          width: double.infinity,
          height: 90,
          alignment: AlignmentDirectional.topCenter,
          // decoration: BoxDecoration(
          //   color: Theme.of(context).scaffoldBackgroundColor,
          // ),
          child: ButtonWidget(
            text: 'к упражнениям',
            color: Colors.white,
            backgroundColor: ColorStyles.green,
            onClick: () {
              log('click on start button');
            },
            minWidth: double.infinity,
            height: 40,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => widget.cubit,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _renderTopBar(),
            body: BlocConsumer<VocabularyCubit, MainState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return _renderBody(context, state);
                })));
  }
}
