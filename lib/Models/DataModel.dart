
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class DataModel {
  final String id;
  final DateTime date;
  final String title;
  late final String note;

  DataModel(
      {required this.date,
      required this.title,
      required this.note,
      required this.id});
//       : id = uuid.v4();
}
