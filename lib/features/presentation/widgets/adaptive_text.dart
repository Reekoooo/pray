import 'package:flutter/material.dart';

class AdaptiveText extends StatelessWidget {

  final String text;

  /// Ratio between the font size and the Height,
  /// so font size will be adaptive to the height available.
  final double fontSizeToHeightRatio;

  /// Styling for the Text
  /// note: the font size will be overridden by a dynamically calculated value.
  final TextStyle style;
  /// Width of the viewport of the text,
  /// if null will follow the max width constraint.
  final double width;
  /// Height of the viewport of the text ,
  /// if null will follow the max height constraint.
  final double height;

  ///Text direction
  final TextDirection textDirection;

  const AdaptiveText({
    Key key,
    this.text,
    this.fontSizeToHeightRatio = 1.0,
    this.style = const TextStyle(),
    this.width,
    this.height,
    this.textDirection = TextDirection.ltr

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          print("text Constrains is $constraints");
          final fontSize = (constraints.maxHeight * fontSizeToHeightRatio);
          final maxLines = (1~/fontSizeToHeightRatio);
          return Text(
            text,
            style: style.copyWith(fontSize: fontSize),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textDirection: textDirection,
          );
        },
      ),
    );
  }
}