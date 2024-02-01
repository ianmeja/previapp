import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import '../data/pollModel.dart';

class PollCardComponent extends StatelessWidget {
  const PollCardComponent({
    this.pollData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final pollModel pollData;
  final Function(pollModel pollData) onTapAction;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 1, 10, 8),
        decoration: BoxDecoration(
          border: Border.all(color: NowUIColors.primary, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: NowUIColors.bgColorScreen,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              onTapAction(pollData);
            },
            //splashColor: color.withAlpha(20),
            //highlightColor: color.withAlpha(10),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${pollData.question}',
                            style: TextStyle(
                                color: NowUIColors.white,
                                fontFamily: 'ZillaSlab',
                                fontSize: 20),
                          ),
                        ],),
                    ],),
                ],
              ),
            ),
          ),
        ));
  }
}