import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/fast_repetition/fast_repetition_cubit.dart';
import '../../styles.dart';
import '../../widgets/button.dart';
import '../../widgets/container_row.dart';
import '../../widgets/content.dart';

class ChooseWordExerciseScreen extends StatefulWidget {
  const ChooseWordExerciseScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChooseWordExerciseScreenState();
}

class ChooseWordExerciseScreenState extends State<ChooseWordExerciseScreen> {
  late FastRepetitionCubit cubit;
  List<String> selected = [];

  @override
  void initState() {
    cubit = context.read<FastRepetitionCubit>();

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
                              video: cubit
                                  .gestures[cubit.currentExercise.answers[0]]
                                  ?.src,
                              img: cubit
                                  .gestures[cubit.currentExercise.answers[0]]
                                  ?.img,
                            ),
                            Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.only(bottom: 20, top: 17),
                                child: ContainerRowWidget(
                                  options: cubit.getGesturesOptions(),
                                  onSelect: (String id) {
                                    selected.add(id);
                                    setState(() {});
                                  },
                                  onRemove: (String id) {
                                    selected.remove(id);
                                    setState(() {});
                                  },
                                )),
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
          'Выберите перевод жеста',
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
            backgroundColor:
                selected.isEmpty ? ColorStyles.gray : ColorStyles.green,
            onClick: () {
              selected.isEmpty ? {} : cubit.checkChooseWordEx(selected);
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
