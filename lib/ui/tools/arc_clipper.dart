import 'package:flutter/material.dart';


class ArcClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip

    size = new Size(size.width, 150);
    var path=  new Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 2, size.height - 20);
    var firstPoint=  new Offset(size.width, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstPoint.dx, firstPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}