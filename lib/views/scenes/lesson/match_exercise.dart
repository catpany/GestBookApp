import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/exercise/exercise_cubit.dart';

import '../../../models/gesture-info.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/content.dart';
import '../../widgets/exercise_popup.dart';

class MatchExerciseScreen extends StatefulWidget {
  const MatchExerciseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MatchExerciseScreenState();
}

class MatchExerciseScreenState extends State<MatchExerciseScreen> {
  List<String> gestures = [];
  CarouselController carouselController = CarouselController();
  late LessonCubit cubit;
  late Iterable<GestureInfoModel> options;
  List<GestureInfoModel> answers = [];
  int selected = 0;
  String selectedOption = '';
  String selectedAnswer = '';
  List<String> matched = [];
  bool _show = false;
  bool _error = false;

  @override
  void initState() {
    cubit = context.read<LessonCubit>();
    options = cubit.getGesturesOptions().values;
    selectedOption = cubit.getGesturesOptions().values.elementAt(selected).id;
    answers = options.toList()..shuffle();

    super.initState();
  }

  Widget _renderBody() {
    return SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            RawScrollbar(
                thumbColor: ColorStyles.gray,
                padding: const EdgeInsets.only(right: 6),
                radius: const Radius.circular(5),
                thickness: 8,
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 9, bottom: 90),
                        child: Column(
                          children: [
                            _renderTitle(),
                            CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: matched.contains(options
                                                    .elementAt(itemIndex)
                                                    .id)
                                                ? ColorStyles.green
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: ContentWidget(
                                          video:
                                              options.elementAt(itemIndex).src,
                                          img: options.elementAt(itemIndex).src,
                                        )),
                                options: CarouselOptions(
                                    height: 232,
                                    initialPage: selected,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: false,
                                    enlargeCenterPage: false,
                                    disableCenter: true,
                                    viewportFraction: 1,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, _) {
                                      matched.contains(
                                              options.elementAt(index).id)
                                          ? setState(() {
                                              selected = index;
                                              selectedOption = '';
                                            })
                                          : setState(() {
                                              selectedOption =
                                                  options.elementAt(index).id;
                                              selected = index;
                                            });
                                    })),
                            _renderIndicator(),
                            _renderAnswers(),
                          ],
                        )))),
            _renderAcceptButton(),
            _renderNextButton(),
          ],
        ));
  }

  Color _getSelectionColor(String selected, String current) {
    return matched.contains(current)
        ? ColorStyles.green
        : selected == current
            ? ColorStyles.cyan
            : ColorStyles.gray;
  }

  Widget _renderAnswers() {
    List<Widget> items = [];

    for (var answer in answers) {
      items.add(GestureDetector(
          onTap: () {
            matched.contains(answer.id)
                ? {}
                : setState(() {
                    selectedAnswer = answer.id;
                  });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: _getSelectionColor(selectedAnswer, answer.id),
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child:
                Text(answer.name, style: Theme.of(context).textTheme.bodySmall),
          )));
    }

    return Wrap(
      children: items,
      spacing: 14,
      runSpacing: 12,
    );
  }

  Widget _renderIndicator() {
    List<Widget> indicators = [];

    for (var index = 0; index < options.length; index++) {
      indicators.add(
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          height: 12,
          width: 12,
          decoration: BoxDecoration(
              color: index == selected ? ColorStyles.green : ColorStyles.gray,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
        ),
      );
    }

    return Wrap(
      children: indicators,
      alignment: WrapAlignment.center,
      spacing: 10,
    );
  }

  Widget _renderTitle() {
    return Container(
        alignment: AlignmentDirectional.centerStart,
        margin: const EdgeInsets.only(bottom: 14, right: 10, left: 10),
        child: Text(
          'Соотнесите жест и его перевод',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ));
  }

  Widget _renderNextButton() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ExercisePopupWidget(
          show: _show,
          error: _error,
          onClick: () {
            setState(() {
              _show = false;
              _error = false;
            });
          },
        ));
  }

  Widget _renderAcceptButton() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 20,
        child: Container(
          padding: const EdgeInsets.only(top: 20, left: 20),
          width: double.infinity,
          height: 100,
          alignment: AlignmentDirectional.topCenter,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: ButtonWidget(
            text: 'Проверить',
            color: Colors.white,
            backgroundColor: selectedAnswer == '' || selectedOption == ''
                ? ColorStyles.gray
                : ColorStyles.green,
            onClick: () {
              cubit.processingMatchAnswer();

              if (selectedAnswer != '' &&
                  selectedOption != '' &&
                  selectedOption == selectedAnswer) {
                matched.add(selectedAnswer);

                if (!cubit.checkMatchEx(matched)) {
                  cubit.correctAnswer();
                  setState(() {
                    selectedOption = '';
                    selectedAnswer = '';
                    _show = true;
                    _error = false;
                  });
                }
              } else if (selectedOption != '' && selectedAnswer != '') {
                cubit.wrongAnswer();
                setState(() {
                  _show = true;
                  _error = true;
                });
              }
            },
            minWidth: double.infinity,
            height: 40,
          ),
        ));
  }

  bool checkMatch() {
    if (selectedOption == selectedAnswer) {
      matched.add(selectedAnswer);
      selectedOption = '';
      selectedAnswer = '';

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
