import 'dart:math';

import 'dart:developer' as dev;
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:sigest/helpers/hexcolor.dart';
import 'package:sigest/models/units.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/lesson.dart';

import '../../models/lesson.dart';
import 'lesson_dialog.dart';

class UnitListWidget extends StatefulWidget {
  final UnitsModel units;
  final Function onStartLesson;

  const UnitListWidget({Key? key, required this.units, required this.onStartLesson}) : super(key: key);

  @override
  _UnitListState createState() => _UnitListState();
}

class _UnitListState extends State<UnitListWidget> {
  String triangleAsset = 'assets/images/triangle.svg';
  String titleAsset = 'assets/images/unit.svg';
  String title = '';
  String triangle = '';
  late PaletteTheme palette;
  int curPage = 0;
  int prevPage = 0;
  CarouselController carouselController = CarouselController();
  late int unitsCount;

  @override
  void initState() {
    palette = PaletteTheme();
    load();
    unitsCount = widget.units.items.length;
    super.initState();
  }

  Future<void> load() async {
    title = await rootBundle.loadString(titleAsset);
    triangle = await rootBundle.loadString(triangleAsset);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //try to load all your data in this method :)
  }

  void changeUnit(int step) {
    setState(() {
      prevPage = curPage;
      curPage = (prevPage + step) % unitsCount;
      step > 0 ? carouselController.nextPage() : carouselController.previousPage();
      title = _updateTitle();
      triangle = _updateTriangle();
    });
  }

  void moveToPage() {
    carouselController.nextPage();
  }

  void updateUnitTitle(int pageIndex) {
    if (pageIndex != curPage) {
      setState(() {
        prevPage = curPage;
        curPage = pageIndex;
        title = _updateTitle();
        triangle = _updateTriangle();
      });
    }
  }

  String _updateTitle() {
    return title
        .replaceAll(palette.palette[prevPage].color.toHexString(),
            palette.palette[curPage].color.toHexString())
        .replaceAll(palette.palette[prevPage].dark.toHexString(),
            palette.palette[curPage].dark.toHexString())
        .replaceAll(palette.palette[prevPage].semi.toHexString(),
            palette.palette[curPage].semi.toHexString());
  }

  String _updateTriangle() {
    return triangle.replaceAll(palette.palette[prevPage].color.toHexString(),
        palette.palette[curPage].color.toHexString());
  }

  Widget _renderLeftButton() {
    return ElevatedButton(
      onPressed: () => changeUnit(-1),
      child: Center(
          child: Transform.rotate(
        angle: 180 * pi / 180,
        child: triangle.isEmpty
            ? SvgPicture.asset(triangleAsset)
            : SvgPicture.string(triangle),
      )),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(5)),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }

  Widget _renderRightButton() {
    return ElevatedButton(
      onPressed: () => changeUnit(1),
      child: Center(
        child: triangle.isEmpty
            ? SvgPicture.asset(triangleAsset)
            : SvgPicture.string(triangle),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(5)),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }

  Widget _renderTitle() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
            child: title.isEmpty
                ? SvgPicture.asset(titleAsset)
                : SvgPicture.string(title)),
        Positioned(
            top: 5,
            child: Text(
              'UNIT ' + (curPage + 1).toString(),
              style: TextStyles.title20SemiBold,
            )),
      ],
    );
  }

  List<Widget> _renderTitleBlock() {
    return [
      _renderLeftButton(),
      _renderTitle(),
      _renderRightButton(),
    ];
  }

  Future<void> _renderLessonDialog(LessonModel lesson) async {
    await showDialog<void>(
        context: context,
      builder: (BuildContext context) {
          return LessonDialogWidget(
            lesson: lesson,
            onStartLesson: widget.onStartLesson,
          );
      }
    );
  }

  Widget _renderLessonList(HiveList<LessonModel> lessons, int unitIndex) {
    return GridView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: true,
        cacheExtent: 15,
        padding: const EdgeInsets.only(top: 12, right: 30, left: 30),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 80,
            mainAxisExtent: 120,
            childAspectRatio: 1.0,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: lessons.length,
        itemBuilder: (BuildContext context, index) {
          return LessonWidget(
              progress: lessons[index].progress,
              icon: lessons[index].icon,
              color: palette.palette[unitIndex].color,
              title: lessons[index].name,
              onTap: () => _renderLessonDialog(lessons[index]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 92,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _renderTitleBlock(),
          ),
        ),
        Expanded(
          child: CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: widget.units.items.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => _renderLessonList(widget.units.items[itemIndex].lessons, itemIndex),
            options: CarouselOptions(
              height: double.infinity,
              initialPage: curPage,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              viewportFraction: 0.9,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, _) {
                updateUnitTitle(index);
              })
            ),
        ),
      ],
    );
  }
}
