import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';
import 'package:sigest/views/widgets/button.dart';

class PopupWindowWidget extends StatelessWidget {
  final String title;
  final String text;
  final Function onAcceptButtonPress;
  final Function onRejectButtonPress;

  const PopupWindowWidget({Key? key, required this.title, required this.text, required this.onAcceptButtonPress, required this.onRejectButtonPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child:
        Container(
          width: 300,
          height: 170,
          padding: const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 10),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children:[
                Text(title, style: TextStyles.text16SemiBold),
                Text(text, style: TextStyles.text14Regular),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ButtonWidget(
                        onClick: onRejectButtonPress,
                        color: ColorStyles.gray,
                        backgroundColor: ColorStyles.white,
                        splashColor: ColorStyles.white,
                        text: 'ОТМЕНА',
                        minWidth: 110,
                        height: 37
                    ),
                    const Spacer(),
                    ButtonWidget(
                        onClick: onAcceptButtonPress,
                        color: ColorStyles.red,
                        backgroundColor: ColorStyles.white,
                        splashColor: ColorStyles.white,
                        text: 'ВЫЙТИ',
                        minWidth: 100,
                        height: 37
                    )
                  ],
                )
              ]
          ),
        )
    );
  }
}