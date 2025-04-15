import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

class DSI_AnalyticCard extends StatelessWidget {
  DSI_AnalyticCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon,
      this.color,
      this.onTap,
      this.isFullWidth,
      this.width});
  final String title, subTitle;
  final bool? isFullWidth;
  final double? width;
  var icon, color;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(DSI_CONFIG.appBorderRadius),
      splashColor: Colors.white,
      onTap: () {
        onTap!();
      },
      child: DSI_CONTAINER(
        margin: const EdgeInsets.all(5),
        height: 70.0,
        color: Colors.white,
        border: const Border(),
        width: width != null
            ? width
            : isFullWidth == true
                ? DSIheightWidth(context, 100, false)
                : DSIheightWidth(context, 45, false),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color ?? const Color.fromARGB(173, 176, 148, 61),
                borderRadius: BorderRadius.circular(
                    // DSI_CONFIG.appBorderRadius,
                    15),
              ),
              child: Icon(
                icon,
                color: DSI_CONFIG.appAccentColor,
              ),
            ),
            DBR(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                H4(
                  text: title.toString() == "null" ? "" : title,
                  fontWeight: FontWeight.bold,
                ),
                Paragraph(text: subTitle.toString() == "null" ? "" : subTitle)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
