
import 'package:flutter/material.dart';

/*class Model {
  const Model(this.country, this.usersCount, this.storage, this.color);

  final String country;
  final double usersCount;
  final String storage;
  final Color  color;
}*/
/// Collection of Australia state code data.
class Model {
  /// Initialize the instance of the [Model] class.
  const Model({this.country, this.state, this.color = Colors.green, });


  final String? country;

  /// Represents the Australia state name.
  final String? state;

  /// Represents the Australia state color.
  final Color? color ;


}