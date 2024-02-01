import 'package:flutter/material.dart';
import 'package:now_ui_flutter/constants/Theme.dart';

class GuestCard extends StatelessWidget {
  GuestCard(
      {this.title = "Placeholder Title",
      this.icon = Icons.check});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
        child: Card(
            elevation: 3,
            shadowColor: NowUIColors.muted.withOpacity(0.22),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(title,
                                style: TextStyle(
                                    color: NowUIColors.secondary, fontSize: 18)),
                            ]
                          ),
                          Column(
                              children: [
                                Icon(this.icon),
                              ]
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
  }
}