import 'package:flutter/material.dart';

class CustomClipperRound extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    /* No metodo lineTO é usado dois parametros x e y para traçar uma reta, ligando os pontos de x até y formando assim uma reta */

    path.lineTo(0.0, size.height);

    var endpoint1 = Offset(size.width * 0.55, size.height - 25.0);
    var controlPoint1 = Offset(size.width * 0.15, size.height - 50.0);

    //o objetivo do quadratic bezier é fazer uma curva com as posicoes declaradas x1,y1 e x2, y2
    path.quadraticBezierTo(
        controlPoint1.dx, controlPoint1.dy, endpoint1.dx, endpoint1.dy);

    var endpoint2 = Offset(size.width, size.height - 80);
    var controlpoint2 = Offset(size.width * 0.8, size.height - 20);
    path.quadraticBezierTo(
        controlpoint2.dx, controlpoint2.dy, endpoint2.dx, endpoint2.dy);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
