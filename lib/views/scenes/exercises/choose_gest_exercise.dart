import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/exercise/exercise_cubit.dart';
import 'package:sigest/models/gesture-info.dart';

import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/content.dart';
import '../../widgets/widget_wrapper.dart';

class ChooseGestExerciseScreen extends StatefulWidget {
  const ChooseGestExerciseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChooseGestExerciseScreenState();
}

class ChooseGestExerciseScreenState extends State<ChooseGestExerciseScreen> {
  late LessonCubit cubit;
  CarouselController carouselController = CarouselController();
  late int selected = 0;
  late Iterable<GestureInfoModel> options;

  @override
  void initState() {
    cubit = context.read<LessonCubit>();
    options = cubit.getGesturesOptions().values;

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
                            left: 15, right: 15, top: 9, bottom: 90),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _renderTitle(),
                            CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ContentWidget(
                                          video:
                                              options.elementAt(itemIndex).src,
                                          img: options.elementAt(itemIndex).img,
                                        )),
                                options: CarouselOptions(
                                    height: 212,
                                    initialPage: selected,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: false,
                                    enlargeCenterPage: false,
                                    disableCenter: true,
                                    viewportFraction: 1,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        selected = index;
                                      });
                                    })),
                            _renderIndicator(),
                            _renderGestureName(),
                          ],
                        )))),
            _renderAcceptButton(),
          ],
        ));
  }

  Widget _renderGestureName() {
    return WidgetWrapper(
        margin: const EdgeInsets.only(right: 5, left: 5, top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 8),
        child: Text(cubit.getAnswer(), style: Theme.of(context).textTheme.bodySmall));
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          'Выберите правильный жест',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
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
            backgroundColor: ColorStyles.green,
            onClick: () {
              cubit.checkChooseGestEx(options.elementAt(selected).id);
            },
            minWidth: double.infinity,
            height: 40,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
