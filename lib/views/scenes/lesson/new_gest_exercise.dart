import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/exercise/exercise_cubit.dart';

import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/content.dart';
import '../../widgets/text_row.dart';
import '../../widgets/widget_wrapper.dart';

class NewGestExerciseScreen extends StatefulWidget {
  const NewGestExerciseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NewGestExerciseScreenState();
}

class NewGestExerciseScreenState extends State<NewGestExerciseScreen> {
  late LessonCubit cubit;

  @override
  void initState() {
    cubit = context.read<LessonCubit>();

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
                            left: 20, right: 20, top: 9, bottom: 90),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _renderTitle(),
                            ContentWidget(
                              video: cubit.gestures[cubit.currentExercise.answers[0]]?.src,
                              img: cubit.gestures[cubit.currentExercise.answers[0]]?.img,
                            ),
                            _renderGestureName(),
                            _renderDescription(),
                          ],
                        )))),
            _renderAcceptButton(),
          ],
        ));
  }

  Widget _renderTitle() {
    return Container(
        alignment: AlignmentDirectional.centerStart,
        margin: const EdgeInsets.only(bottom: 14),
        child: Text(
          'Выучите новое слово',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.start,
        ));
  }

  Widget _renderGestureName() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 4),
      constraints: const BoxConstraints(
        minHeight: 80,
      ),
      child: TextRowWidget(
        text: cubit.gestures[cubit.currentExercise.answers[0]]?.name ?? '',
      ),
    );
  }

  Widget _renderDescription() {
    String? desc = cubit.gestures[cubit.currentExercise.answers[0]]?.description;

    if (null != desc) {
      return Container(
          constraints: const BoxConstraints(
            minHeight: 100,
          ),
          margin: const EdgeInsets.only(top: 20, bottom: 24),
          child: WidgetWrapper(
            alignment: AlignmentDirectional.topStart,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            child:
            Text(desc,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall),
          ));
    } else {
      return const SizedBox.shrink();
    }
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
            text: 'Понятно',
            color: Colors.white,
            backgroundColor: ColorStyles.green,
            onClick: () {cubit.checkNewWordEx();},
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
