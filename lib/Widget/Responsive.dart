import 'package:flutter/cupertino.dart';

class Responsive extends StatelessWidget {
  Responsive(
      {required this.largeScreen,
      this.mediumScreen,
      this.smallScreen,
      this.tooLargeScreen});
  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final Widget? tooLargeScreen;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 700;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.height > 860 &&
        MediaQuery.of(context).size.height <= 1000;
  }

  static bool isTooLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.height > 1000;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.height >= 700 &&
        MediaQuery.of(context).size.height <= 860;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > 1000) {
          return tooLargeScreen!;
        } else if (constraints.maxHeight > 860 &&
            constraints.maxHeight <= 1000) {
          return largeScreen!;
        } else if (constraints.maxHeight <= 860 &&
            constraints.maxHeight >= 700) {
          return mediumScreen ?? largeScreen!;
        } else {
          return mediumScreen ?? smallScreen!;
        }
      },
    );
  }
}
