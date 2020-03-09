import 'package:flutter/material.dart';
import 'package:pray/features/presentation/bloc/bloc.dart';
import 'package:pray/features/presentation/widgets/menu_tile.dart';
import 'package:provider/provider.dart';

class AzanTileMenu extends StatefulWidget {
  const AzanTileMenu({
    Key key,
  }) : super(key: key);

  @override
  _AzanTileMenuState createState() => _AzanTileMenuState();
}

class _AzanTileMenuState extends State<AzanTileMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _scaleController;
  Animation _shrinkAnimation;
  Animation _expandAnimation;
  Animation _stayExpandedAnimation;
  Animation _stayShrinkAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..forward(from: 0.0);

    _shrinkAnimation = Tween(begin: 1.0, end: 0.5)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.ease));
    _expandAnimation = Tween(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.ease));
    _stayExpandedAnimation =
        Tween(begin: 1.0, end: 1.0).animate(_scaleController);
    _stayShrinkAnimation =
        Tween(begin: 0.5, end: 0.5).animate(_scaleController);
  }

  Animation _getAnimation(int index, int selected, int prevSelected) {
    if (index == selected && index == prevSelected) {
      return _stayExpandedAnimation;
    }
    if (index == selected && index != prevSelected) {
      return _expandAnimation;
    }
    if (index != selected && index == prevSelected) {
      return _shrinkAnimation;
    }
    if (index != selected && index != prevSelected) {
      return _stayShrinkAnimation;
    }
    return null;
  }

  bool _shouldAnimate(int index, int selected, int prevSelected) =>
      !(index == selected && index == prevSelected);

  DayTimings model;

  @override
  void didChangeDependencies() {
    // TODO: implement
    super.didChangeDependencies();
    model = Provider.of<DayTimings>(context);
    // _scaleController.forward(from:1-_scaleController.value);
    print("AzanTileMenue  didChangeDependencies called");
  }

  @override
  Widget build(BuildContext context) {
    final azans = ["الفجر", "الظهر", "العصر", "المغرب", "العشاء"];
    print(
        "index = 0 selected = ${model.selected} prevSelected = ${model.prevSelected}");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: azans
          .asMap()
          .map(
            (index, azan) {
              final _animation =
                  _getAnimation(index, model.selected, model.prevSelected);

              final _onTileTap = () {
                model.selected = index;
                print(
                    "index = $index selected = ${model.selected} prevSelected = ${model.prevSelected}");
                if (_shouldAnimate(index, model.selected, model.prevSelected)) {
                  setState(() {});
                  _scaleController.forward(from: 1 - _scaleController.value);
                }
              };
              print("Media Query size is ${MediaQuery.of(context).size}");
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height / 5;

              final tile = AzanMenuTile(
                width: width,
                // 300.0,
                height: height,
                //130.0,
                time: model.timings[index],
                timeStyle: TextStyle(fontFamily: 'NeoSans'),
                azanStyle: TextStyle(fontFamily: 'NeoSans'),

                timeFontSizeToHeightRatio: 0.2,
                azan: azan,
                azanFontSizeToHeightRatio: 0.5,
                mirrored: false,
              );
              final decoration = BoxDecoration(
                color: Colors.white.withOpacity(0.1),
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(height / 2),
//                  bottomLeft: Radius.circular(height / 2),
//                ),
//                boxShadow: [
//                  BoxShadow(
//                      offset: Offset(0.0, 5.0),
//                      color: Colors.black.withOpacity(0.2),
//                      blurRadius: 2.0)
//                ],
              );

              return MapEntry(
                index,
                SizeTransition(
                  sizeFactor: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _onTileTap,
                      child: Container(
                        decoration: decoration,
                        child: tile,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }
}
