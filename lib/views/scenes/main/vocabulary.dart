import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigest/bloc/main_cubit.dart';
import 'package:sigest/views/styles.dart';

import '../../../bloc/vocabulary/vocabulary_cubit.dart';

class VocabularyScreen extends StatefulWidget {
  VocabularyScreen({Key? key}) : super(key: key);
  final VocabularyCubit cubit = VocabularyCubit();

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  Map<String, String> letters = {
    'А': 'A',
    'Б': 'B',
    'В': 'V',
    'Г': 'G',
    'Д': 'D',
    'Е': 'E',
    'Ё': 'Yo',
    'Ж': 'Zh',
    'З': 'Z',
    'И': 'I',
    'Й': 'J',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'Ф': 'F',
    'Ц': 'Ts',
    'Ч': 'Ch',
    'Ш': 'Sh',
    'Щ': 'Shch',
    'Ь': 'Ss',
    'Ы': 'Y',
    'Ъ': 'Hs',
    'Э': 'Aa',
    'Ю': 'You',
    'Я': 'Ya',
  };

  @override
  void initState() {
    super.initState();
    widget.cubit.load();
  }

  PreferredSizeWidget _renderTopBar() {
    return AppBar(
      title: Text('ДАКТИЛЬНАЯ АЗБУКА', style: Theme.of(context).textTheme.titleSmall),
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

    for (final letter in letters.entries) {
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
                    'assets/images/vocabulary/' + letter.value + '.svg',
                    width: 62,
                    height: 62)),
            // Positioned(
            //     right: 10,
            //     bottom: -5,
            //     child: Text(
            //       letter,
            //       style: TextStyle(
            //         fontFamily: 'Comfortaa',
            //         fontWeight: FontWeight.w500,
            //         fontSize: 40,
            //         foreground: Paint()
            //           ..style = PaintingStyle.stroke
            //           ..strokeWidth = 2
            //           ..color =
            //           Colors.white.withOpacity(0.9),
            //       ),
            //     )),
            Positioned(
                right: 10,
                bottom: -5,
                child: Text(
                  letter.key,
                  style: const TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    color: ColorStyles.accent,
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
        _renderStartButton()
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
          // child: ButtonWidget(
          //   text: 'к упражнениям',
          //   color: Colors.white,
          //   backgroundColor: ColorStyles.green,
          //   onClick: () {
          //     log('click on start button');
          //   },
          //   minWidth: double.infinity,
          //   height: 40,
          // ),
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
