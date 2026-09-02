import 'package:isar/isar.dart';

part 'centre_model.g.dart';

@collection
class CentreModel {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  String centreId;
  @Index()
  String state;
  @Index()
  String district;
  String centreName;
  int capacity;

  CentreModel({
    required this.centreId,
    required this.state,
    required this.district,
    required this.centreName,
    required this.capacity,
  });
}