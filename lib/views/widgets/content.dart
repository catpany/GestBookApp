import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/video_player.dart';

import '../../main.dart';
import '../styles.dart';

class ContentWidget extends StatefulWidget {
  final String? video;
  final String? img;

  const ContentWidget({
    Key? key,
    required this.video,
    required this.img,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {

  Widget _loadingFrame(Widget child) {
    return Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 212,
        ),
        decoration: const BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: child,
        ));
  }

  Widget _showError() {
    return Container(
      decoration: const BoxDecoration(
          color: ColorStyles.gray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      alignment: AlignmentDirectional.center,
      width: double.infinity,
      height: 212,
      child: Text(
        'Ресурс недоступен',
        style: TextStyles.title20SemiBold?.apply(color: ColorStyles.grayDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String src;

    if (widget.video != null) {
      src = widget.video ?? '';

      if (src.startsWith('http')) {
        return VideoPlayerWidget(
            src: src.replaceAll('localhost:8000', config["domain"]));
      }

      return VideoPlayerWidget(
        src: src,
        fromNetwork: false,
      );
    }

    if (widget.img != null) {
      src = widget.img ?? '';

      if (src.startsWith('http')) {
        return Image.network(
          src.replaceAll('localhost:8000', config["domain"]),
          errorBuilder: (BuildContext context, error, _) => _showError(),
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? event) {
            return _loadingFrame(child);
          },
          frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
            return _loadingFrame(child);
          },
        );
      }

      return Image.file(
        File(src),
        errorBuilder: (BuildContext context, error, _) => _showError(),
        frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
          return _loadingFrame(child);
        },
      );
    }

    return _showError();
  }
}
