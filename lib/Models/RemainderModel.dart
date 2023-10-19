import 'package:flutter/material.dart';

class RemainderModel {
  final String id;
  final int rid;
  final String title;
  final String note;
  final DateTime date;
  final DateTime rdate;
  RemainderModel(
      {required this.rid,
      required this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.rdate});
}
