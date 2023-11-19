import 'package:flutter/material.dart';
import '../styles.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  PreferredSizeWidget _renderTopBar(BuildContext context) {
    return AppBar(
      title: Text('О ПРИЛОЖЕНИИ', style: Theme.of(context).textTheme.titleSmall),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _renderTopBar(context),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Text('Приложение разработано студентами Томского государственного университета систем управления и радиоэлектроники Жук Анастасией и Сафоненко Ангелиной \n Контакты для связи:\n adz22@mail.ru', style: Theme.of(context).textTheme.bodySmall),
        ),
  );
  }
}
