import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Providers/EmailPassProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:bottom/Models/RemainderModel.dart';

class DataBaseNotifier extends StateNotifier<List<DataModel>> {
  DataBaseNotifier(this.ref) : super(const []);
  Ref ref;

  void addNote(DataModel Note) async {
    ref.read(idustateprovider.notifier).state = true;

    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .doc(Note.id)
        .set({
      'Id': Note.id,
      'Date': Note.date.toString(),
      'Title': Note.title,
      'Note': Note.note,
    });
    state = [Note, ...state];
    ref.read(idustateprovider.notifier).state = false;
  }

  Future<DataModel> delete(DataModel Note) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .doc(Note.id)
        .delete();
    int ind = state.indexOf(Note);
    final delNote = state.removeAt(ind);
    state = [...state];
    return delNote;
  }

  void update(DataModel Note) async {
    ref.read(idustateprovider.notifier).state = true;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .doc(Note.id)
        .set({
      'Id': Note.id,
      'Date': Note.date.toString(),
      'Title': Note.title,
      'Note': Note.note,
    });
    getData();
    ref.read(idustateprovider.notifier).state = false;
  }

  Future<List<DataModel>> getData() async {
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .get();

    final dataList = data.docs
        .map((row) => DataModel(
            id: row['Id'] as String,
            date: DateTime.parse(row['Date'] as String),
            title: row['Title'] as String,
            note: row['Note'] as String))
        .toList();

    state = dataList;
    return dataList;
  }
}

final DataBaseProvider =
    StateNotifierProvider<DataBaseNotifier, List<DataModel>>(
        (ref) => DataBaseNotifier(ref));
