import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/exercise/exercise_cubit.dart';

import '../../../models/gesture-info.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/content.dart';
import '../../widgets/widget_wrapper.dart';

class YesNoExerciseScreen extends StatefulWidget {
  const YesNoExerciseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => YesNoExerciseScreenState();
}

class YesNoExerciseScreenState extends State<YesNoExerciseScreen> {
  late LessonCubit cubit;

  @override
  void initState() {
    cubit = context.read<LessonCubit>();

    super.initState();
  }

  Widget _renderBody() {
    GestureInfoModel gesture = cubit.getGesturesOptions().values.first;

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
                            left: 20, right: 20, top: 9, bottom: 90),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _renderTitle(),
                            ContentWidget(
                              video: gesture.src,
                              img: gesture.img,
                            ),
                            WidgetWrapper(
                                margin: const EdgeInsets.only(top: 50),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 34, vertical: 8),
                                child: Text(cubit.getAnswer(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall)),
                          ],
                        )))),
            _renderAcceptButtons(),
          ],
        ));
  }

  Widget _renderTitle() {
    return Container(
        alignment: AlignmentDirectional.centerStart,
        margin: const EdgeInsets.only(bottom: 14),
        child: Text(
          'Соответствует ли жест переводу?',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ));
  }

  Widget _renderAcceptButtons() {
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
          child: Row(children: [
            Flexible(
                child: Container(
                    margin: const EdgeInsets.only(right: 18),
                    child: ButtonWidget(
                      text: 'Да',
                      color: Colors.white,
                      backgroundColor: ColorStyles.green,
                      onClick: () {cubit.checkYesNoEx(true);},
                      minWidth: double.infinity,
                      height: 50,
                    ))),
            Flexible(
                child: ButtonWidget(
              text: 'Нет',
              color: Colors.white,
              backgroundColor: ColorStyles.red,
              onClick: () {cubit.checkYesNoEx(false);},
              minWidth: double.infinity,
              height: 50,
            )),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _renderBody();
  }
}
