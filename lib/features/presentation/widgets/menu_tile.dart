import 'package:flutter/material.dart';
import 'package:pray/features/presentation/widgets/adaptive_text.dart';
import 'package:pray/features/presentation/widgets/tile_painter.dart';

class AzanTextTile extends StatelessWidget {
  final double width;
  final double height;
  final AdaptiveText startText;
  final AdaptiveText endText;

  const AzanTextTile({
    Key key,
    this.width,
    this.height,
    this.startText,
    this.endText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle

            ),

            child: SizedBox(
              height: height,
              width: height,
              child: Center(child: startText),
            ),
          ),
          endText
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final double width;
  final double height;
  final CustomPainter painter;
  final Widget child;

  const MenuTile({
    Key key,
    this.width,
    this.height,
    this.painter,
    this.child = const CustomPaint(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.all(height / 40),
        child: CustomPaint(
          painter: painter,
          child: child,
        ),
      ),
    );
  }
}

class AzanMenuTile extends StatelessWidget {
  final double width;
  final double height;
  final bool mirrored;
  final String time;
  final double timeFontSizeToHeightRatio;
  final TextStyle timeStyle;

  final String azan;
  final double azanFontSizeToHeightRatio;
  final TextStyle azanStyle;

  const AzanMenuTile({
    Key key,
    this.width,
    this.height,
    this.mirrored = false,
    this.time = '',
    this.timeFontSizeToHeightRatio = 1.0,
    this.timeStyle = const TextStyle(),
    this.azan = '',
    this.azanFontSizeToHeightRatio = 1.0,
    this.azanStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Azan menu tile build");
    return MenuTile(
      width: width,
      height: height,
      painter: TilePainter(mirrored: mirrored),
      child: AzanTextTile(
        width: width,
        height: height,
        startText: AdaptiveText(
          text: time,
          fontSizeToHeightRatio: timeFontSizeToHeightRatio,
          style: timeStyle,
          textDirection: TextDirection.ltr,
        ),
        endText: AdaptiveText(
          text: azan,
          fontSizeToHeightRatio: azanFontSizeToHeightRatio,
          style: azanStyle,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

//    return AnimatedBuilder(
//
//      animation: controller,
//
//      builder: (context,child){
//        return Transform.scale(
//          scale: controller.value,
//          child: child,
//        );
//      },
//
//      child: Container(
//        width: width,
//        height: height,
//
//        child: CustomPaint(
//          painter: painter,
//          child: child,
//        ),
//      ),
//    );
//  }

//class AnimatedMenuTile extends StatelessWidget {
//  final double width;
//  final double height;
//  final BoxDecoration decoration;
//  final Widget child;
//  final CustomPainter painter;
//  final Duration duration;
//  final Curve curve;
//  final VoidCallback onTap;
//
//  const AnimatedMenuTile({
//    Key key,
//    this.width,
//    this.height,
//    this.decoration,
//    @required this.painter,
//    this.duration = const Duration(milliseconds: 200),
//    this.curve = Curves.linear,
//    this.child,
//    this.onTap,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: onTap,
//      child: AnimatedContainer(
//        height: height,
//        width: width,
//        duration: duration,
//        curve: curve,
//        decoration: decoration,
//        child: CustomPaint(
//          painter: painter,
//          child: child,
//        ),
//      ),
//    );
//  }
//}
