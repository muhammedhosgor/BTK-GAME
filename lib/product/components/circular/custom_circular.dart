import 'package:flutter/material.dart';
import 'package:flutter_base_app/product/functions/optimus_prime/optimus_prime.dart';

class CircularIndicatorWidget extends StatelessWidget {
  CircularIndicatorWidget({
    super.key,
    this.color,
  });

  Color? color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: ResponsiveFontSize.optimusPrime(2.2),
      color: color ?? Theme.of(context).primaryColor,
    );
  }
}
