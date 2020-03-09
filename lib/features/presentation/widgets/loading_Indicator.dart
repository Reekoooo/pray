import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            width: 100,
          ),
        ),
        SizedBox(
          width: 50,
          height: 50.0,
          child: CircularProgressIndicator(),
        ),
        Expanded(
          child: Container(
            width: 100,
          ),
        ),
      ],
    );
  }
}