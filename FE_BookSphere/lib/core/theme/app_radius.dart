import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const sm = Radius.circular(8);
  static const md = Radius.circular(12);
  static const lg = Radius.circular(16);

  static const smBorder = BorderRadius.all(sm);
  static const mdBorder = BorderRadius.all(md);
  static const lgBorder = BorderRadius.all(lg);
}
