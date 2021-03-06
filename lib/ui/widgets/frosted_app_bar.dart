import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedAppBar extends StatefulWidget {
  //
  double height;
  Widget title;
  bool leading;
  List<Widget> actions;
  Color color;
  double blurStrengthX;
  double blurStrengthY;
  //constructor
  FrostedAppBar({
    this.height,
    this.actions,
    this.blurStrengthX,
    this.blurStrengthY,
    this.color,
    this.leading,
    this.title,
  });
  //
  @override
  _FrostedAppBarState createState() => _FrostedAppBarState();
}

class _FrostedAppBarState extends State<FrostedAppBar> {
  @override
  Widget build(BuildContext context) {
    var scrSize = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            // will be 10 by default if not provided
            sigmaX: widget.blurStrengthX ?? 10,
            sigmaY: widget.blurStrengthY ?? 10,
          ),
          child: Container(
            color: widget.color, //test
            alignment: Alignment.center,
            width: scrSize.width,
            height: widget.height ?? 100,
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: widget.leading ?? true,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              actions: widget.actions,
            ),
          ),
        ),
      ), // to clip the container
    );
  }
}
