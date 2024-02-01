import 'package:flutter/material.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      {this.title,
      this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = NowUIColors.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(top: 6),
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? NowUIColors.primary
                      : NowUIColors.white.withOpacity(0.8)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(title,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        color: isSelected
                            ? NowUIColors.primary
                            : NowUIColors.white)),
              )
            ],
          )),
    );
  }
}
